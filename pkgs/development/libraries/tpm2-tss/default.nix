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

stdenv.mkDerivation rec {
  pname = "tpm2-tss";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = pname;
    rev = version;
    hash = "sha256-BP28utEUI9g1VNv3lCXuiKrDtEImFQxxZfIjLiE3Wr8=";
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

  buildInputs =
    [
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
    ++ lib.optional doInstallCheck cmocka;

  nativeInstallCheckInputs = [
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

    # Configure script expects tools from shadow (e.g. useradd) but they are
    # actually optional (and we can’t use them in Nix sandbox anyway). Make the
    # check in configure.ac a warning instead of an error so that we can run
    # configure phase on platforms that don’t have shadow package (e.g. macOS).
    # Note that *on platforms* does not mean *for platform* i.e. this is for
    # cross-compilation, tpm2-tss does not support macOS, see upstream issue:
    # https://github.com/tpm2-software/tpm2-tss/issues/2629
    # See also
    # https://github.com/tpm2-software/tpm2-tss/blob/6c46325b466f35d40c2ed1043bfdfcfb8a367a34/Makefile.am#L880-L898
    ./no-shadow.patch
  ];

  postPatch =
    ''
      patchShebangs script
      substituteInPlace src/tss2-tcti/tctildr-dl.c \
        --replace-fail '@PREFIX@' $out/lib/
      substituteInPlace ./test/unit/tctildr-dl.c \
        --replace-fail '@PREFIX@' $out/lib/
      substituteInPlace ./bootstrap \
        --replace-fail 'git describe --tags --always --dirty' 'echo "${version}"'
      for src in src/tss2-tcti/tcti-libtpms.c test/unit/tcti-libtpms.c; do
        substituteInPlace "$src" \
          --replace-fail '"libtpms.so"' '"${libtpms.out}/lib/libtpms.so"' \
          --replace-fail '"libtpms.so.0"' '"${libtpms.out}/lib/libtpms.so.0"'
      done
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

  configureFlags = lib.optionals doInstallCheck [
    "--enable-unit"
    "--enable-integration"
  ];

  postInstall = ''
    # Do not install the upstream udev rules, they rely on specific
    # users/groups which aren't guaranteed to exist on the system.
    rm -R $out/lib/udev
  '';

  doCheck = false;
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  # Since we rewrote the load path in the dynamic loader for the TCTI
  # The various tcti implementation should be placed in their target directory
  # before we could run tests, so we make turn checkPhase into installCheckPhase
  installCheckTarget = "check";

  meta = with lib; {
    description = "OSS implementation of the TCG TPM2 Software Stack (TSS2)";
    homepage = "https://github.com/tpm2-software/tpm2-tss";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ baloo ];
  };
}
