{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  doxygen,
  perl,
  openssl,
  json_c,
  curl,
  libgcrypt,
  cmocka,
  uthash,
  swtpm,
  iproute2,
  procps,
  which,
  libuuid,
  libtpms,
}:
let
  # Avoid a circular dependency on Linux systems (systemd depends on tpm2-tss,
  # tpm2-tss tests depend on procps, procps depends on systemd by default). This
  # needs to be conditional based on isLinux because procps for other systems
  # might not support the withSystemd option.
  procpsWithoutSystemd = procps.override { withSystemd = false; };
  procps_pkg = if stdenv.hostPlatform.isLinux then procpsWithoutSystemd else procps;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "tpm2-tss";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-MNrVKoA2sW3wKaQsq27UtakzdKmfirtDCoPWu0EEndw=";
  };

  outputs = [
    "out"
    "man"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    doxygen
    perl
  ];

  buildInputs = [
    openssl
    json_c
    curl
    libgcrypt
    uthash
    libuuid
    libtpms
  ]
  # cmocka is checked in the configure script
  # when unit and/or integration testing is enabled
  # cmocka doesn't build with pkgsStatic, and we don't need it anyway
  # when tests are not run
  ++ lib.optional finalAttrs.doInstallCheck cmocka;

  nativeInstallCheckInputs = lib.optionals finalAttrs.doInstallCheck [
    cmocka
    which
    openssl
    procps_pkg
    iproute2
    swtpm
  ];

  strictDeps = true;
  preAutoreconf = "./bootstrap";

  enableParallelBuilding = true;

  patches = [
    # Do not rely on dynamic loader path
    # TCTI loader relies on dlopen(), this patch prefixes all calls with the output directory
    ./no-dynamic-loader-path.patch
  ];

  postPatch = ''
    patchShebangs script
    substituteInPlace src/tss2-tcti/tctildr-dl.c \
      --replace-fail '@PREFIX@' $out/lib/
    substituteInPlace ./test/unit/tctildr-dl.c \
      --replace-fail '@PREFIX@' $out/lib/
    substituteInPlace ./bootstrap \
      --replace-fail 'git describe --tags --always --dirty' 'echo "${finalAttrs.version}"'
    for src in src/tss2-tcti/tcti-libtpms.c test/unit/tcti-libtpms.c; do
      substituteInPlace "$src" \
        --replace-fail '"libtpms.so"' '"${libtpms.out}/lib/libtpms.so"' \
        --replace-fail '"libtpms.so.0"' '"${libtpms.out}/lib/libtpms.so.0"'
    done
    substituteInPlace src/tss2-fapi/ifapi_config.c \
      --replace-fail 'SYSCONFDIR' '"/etc"'
  ''
  # tcti tests rely on mocking function calls, which appears not to be supported
  # on clang
  + lib.optionalString stdenv.cc.isClang ''
    sed -i '/TESTS_UNIT / {
      /test\/unit\/tcti-swtpm/d;
      /test\/unit\/tcti-mssim/d;
      /test\/unit\/tcti-device/d
    }' Makefile-test.am
  '';

  configureFlags =
    lib.optionals finalAttrs.doInstallCheck [
      "--enable-unit"
      "--enable-integration"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # sys/prctl.h required
      "--disable-tcti-cmd"
      # uchar.h required
      "--disable-fapi"
      "--disable-policy"
      # uses fallocate
      "--disable-tcti-libtpms"
    ];

  postInstall = ''
    # Do not install the upstream udev rules, they rely on specific
    # users/groups which aren't guaranteed to exist on the system.
    rm -R $out/lib/udev

    mkdir -p $out/etc/tpm2-tss

    # write fapi-config suitable for testing
    cat > $out/etc/tpm2-tss/fapi-config-test.json <<EOF
    {
      "profile_dir": "${placeholder "out"}/etc/tpm2-tss/fapi-profiles/",
      "system_pcrs" : []
    }
    EOF
  '';

  doCheck = false;
  doInstallCheck =
    stdenv.buildPlatform.canExecute stdenv.hostPlatform
    && !stdenv.hostPlatform.isDarwin
    # Tests rely on mocking, which can't work with static libs.
    && !stdenv.hostPlatform.isStatic
    # swtpm does not build on 32-bit targets
    && !stdenv.hostPlatform.is32bit;
  # Since we rewrote the load path in the dynamic loader for the TCTI
  # The various tcti implementation should be placed in their target directory
  # before we could run tests, so we make turn checkPhase into installCheckPhase
  installCheckTarget = "check";

  meta = {
    description = "OSS implementation of the TCG TPM2 Software Stack (TSS2)";
    homepage = "https://github.com/tpm2-software/tpm2-tss";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      baloo
      scottstephens
    ];
  };
})
