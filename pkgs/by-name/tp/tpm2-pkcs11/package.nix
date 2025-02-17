{
  autoconf-archive,
  autoreconfHook,
  buildEnv,
  clangStdenv,
  cmocka,
  dbus,
  expect,
  fetchFromGitHub,
  glibc,
  gnutls,
  iproute2,
  lib,
  libyaml,
  makeWrapper,
  opensc,
  openssh,
  openssl,
  nss,
  p11-kit,
  patchelf,
  pkg-config,
  python3,
  stdenv,
  sqlite,
  swtpm,
  tpm2-abrmd,
  tpm2-openssl,
  tpm2-pkcs11, # for passthru abrmd tests
  tpm2-tools,
  tpm2-tss,
  which,
  xxd,
  abrmdSupport ? false,
  fapiSupport ? true,
  enableFuzzing ? false,
}:

let
  chosenStdenv = if enableFuzzing then clangStdenv else stdenv;
in
chosenStdenv.mkDerivation (finalAttrs: {
  pname = "tpm2-pkcs11";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = "tpm2-pkcs11";
    tag = finalAttrs.version;
    hash = "sha256-W74ckrpK7ypny1L3Gn7nNbOVh8zbHavIk/TX3b8XbI8=";
  };

  # Disable Java‐based tests because of missing dependencies
  patches = [ ./disable-java-integration.patch ];

  postPatch = ''
    echo ${lib.escapeShellArg finalAttrs.version} >VERSION

    # Don't run git in the bootstrap
    substituteInPlace bootstrap --replace-warn "git" "# git"

    # Provide configuration file for D-Bus
    substituteInPlace Makefile.am --replace-fail \
      "dbus-run-session" \
      "dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf"

    # Disable failing tests
    sed -E -i '/\<test\/integration\/(pkcs-crypt\.int|pkcs11-tool\.sh)\>/d' \
      Makefile-integration.am

    patchShebangs test tools

    # The preConfigure phase doesn't seem to be working here
    # ./bootstrap MUST be executed as the first step, before all
    # of the autoreconfHook stuff
    ./bootstrap
  '';

  configureFlags =
    [
      (lib.enableFeature finalAttrs.doCheck "unit")
      (lib.enableFeature finalAttrs.doCheck "integration")
    ]
    ++ lib.optionals enableFuzzing [
      "--enable-fuzzing"
      "--disable-hardening"
    ]
    ++ lib.optional fapiSupport "--with-fapi";

  strictDeps = true;

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    makeWrapper
    patchelf
    pkg-config
    (python3.withPackages (
      ps:
      with ps;
      [
        packaging
        pyyaml
        python-pkcs11
        cryptography
        pyasn1-modules
        tpm2-pytss
      ]
      ++ cryptography.optional-dependencies.ssh
    ))
  ];

  buildInputs = [
    libyaml
    opensc
    openssl
    sqlite
    tpm2-tools
    tpm2-tss
  ];

  nativeCheckInputs = [
    dbus
    expect
    gnutls
    iproute2
    nss.tools
    opensc
    openssh
    openssl
    p11-kit
    sqlite
    swtpm
    tpm2-abrmd
    tpm2-tools
    which
    xxd
  ];

  checkInputs = [
    cmocka
    tpm2-abrmd
  ];

  enableParallelBuilding = true;
  hardeningDisable = lib.optional enableFuzzing "all";

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  doCheck = true;
  dontStrip = true;
  dontPatchELF = true;

  preCheck =
    let
      openssl-modules = buildEnv {
        name = "openssl-modules";
        pathsToLink = [ "/lib/ossl-modules" ];
        paths = map lib.getLib [
          openssl
          tpm2-openssl
        ];
      };
    in
    ''
      # Enable tests to load TCTI modules
      export LD_LIBRARY_PATH+=":${
        lib.makeLibraryPath [
          swtpm
          tpm2-tools
          tpm2-abrmd
        ]
      }"

      # Enable tests to load TPM2 OpenSSL module
      export OPENSSL_MODULES="${openssl-modules}/lib/ossl-modules"
    '';

  postInstall = ''
    mkdir -p $bin/bin/ $bin/share/tpm2_pkcs11/
    mv ./tools/* $bin/share/tpm2_pkcs11/
    makeWrapper $bin/share/tpm2_pkcs11/tpm2_ptool.py $bin/bin/tpm2_ptool \
      --prefix PATH : ${lib.makeBinPath [ tpm2-tools ]}
  '';

  # To be able to use the userspace resource manager, the RUNPATH must
  # explicitly include the tpm2-abrmd shared libraries.
  preFixup =
    let
      rpath = lib.makeLibraryPath (
        [
          glibc
          libyaml
          openssl
          sqlite
          tpm2-tss
        ]
        ++ (lib.optional abrmdSupport tpm2-abrmd)
      );
    in
    ''
      patchelf \
        --set-rpath ${rpath} \
        ${lib.optionalString abrmdSupport "--add-needed ${lib.makeLibraryPath [ tpm2-abrmd ]}/libtss2-tcti-tabrmd.so"} \
        --add-needed ${lib.makeLibraryPath [ tpm2-tss ]}/libtss2-tcti-device.so \
        $out/lib/libtpm2_pkcs11.so.0.0.0
    '';

  passthru = {
    tests.tpm2-pkcs11-abrmd = tpm2-pkcs11.override {
      abrmdSupport = true;
    };
  };

  meta = {
    description = "PKCS#11 interface for TPM2 hardware";
    homepage = "https://github.com/tpm2-software/tpm2-pkcs11";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ numinit ];
    mainProgram = "tpm2_ptool";
  };
})
