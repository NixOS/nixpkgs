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
  nix-update-script,
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
  tpm2-pkcs11, # for passthru tests
  tpm2-pkcs11-esapi,
  tpm2-pkcs11-fapi,
  tpm2-tools,
  tpm2-tss,
  which,
  xxd,
  abrmdSupport ? false,
  fapiSupport ? true,
  defaultToFapi ? false,
  enableFuzzing ? false,
  extraDescription ? null,
}:

let
  chosenStdenv = if enableFuzzing then clangStdenv else stdenv;
in
chosenStdenv.mkDerivation (finalAttrs: {
  pname = "tpm2-pkcs11";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = "tpm2-pkcs11";
    tag = finalAttrs.version;
    hash = "sha256-o0a5MiFqLH7SuHG/BEtPVGOaDoV+kCu2l1MCHt5rWFc=";
  };

  # Disable Java‐based tests because of missing dependencies
  patches =
    lib.singleton ./disable-java-integration.patch
    ++ lib.optional defaultToFapi ./default-to-fapi.patch;

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

  configureFlags = [
    (lib.enableFeature finalAttrs.doCheck "unit")
    (lib.enableFeature finalAttrs.doCheck "integration")

    # Strangely, it uses --with-fapi=yes|no instead of a normal configure flag.
    "--with-fapi=${lib.boolToYesNo fapiSupport}"
  ]
  ++ lib.optionals enableFuzzing [
    "--enable-fuzzing"
    "--disable-hardening"
  ];

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
    ''
    + lib.optionalString defaultToFapi ''
      # Need to change the default since the tests expect the other way.
      export TPM2_PKCS11_BACKEND=esysdb
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

  passthru = rec {
    esapi = tpm2-pkcs11-esapi;
    fapi = tpm2-pkcs11-fapi;
    abrmd = tpm2-pkcs11.override {
      abrmdSupport = true;
    };
    esapi-abrmd = tpm2-pkcs11-esapi.override {
      abrmdSupport = true;
    };
    fapi-abrmd = tpm2-pkcs11-fapi.override {
      abrmdSupport = true;
    };
    tests = {
      inherit
        esapi
        fapi
        abrmd
        esapi-abrmd
        fapi-abrmd
        ;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description =
      "PKCS#11 interface for TPM2 hardware"
      + lib.optionalString (extraDescription != null) " ${extraDescription}";
    homepage = "https://github.com/tpm2-software/tpm2-pkcs11";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ numinit ];
    mainProgram = "tpm2_ptool";
  };
})
