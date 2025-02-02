{
  autoconf-archive,
  autoreconfHook,
  clangStdenv,
  cmocka,
  fetchFromGitHub,
  glibc,
  lib,
  libyaml,
  makeWrapper,
  opensc,
  openssl,
  patchelf,
  pkg-config,
  python3,
  stdenv,
  sqlite,
  tpm2-abrmd,
  tpm2-pkcs11, # for passthru abrmd tests
  tpm2-tools,
  tpm2-tss,
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

  # The preConfigure phase doesn't seem to be working here
  # ./bootstrap MUST be executed as the first step, before all
  # of the autoreconfHook stuff
  postPatch = ''
    echo "$version" > VERSION

    # Don't run git in the bootstrap
    substituteInPlace bootstrap --replace-warn "git" "# git"

    # Don't run tests with dbus
    substituteInPlace Makefile.am --replace-fail "dbus-run-session" "env"

    patchShebangs test

    ./bootstrap
  '';

  configureFlags =
    lib.singleton (lib.enableFeature finalAttrs.doCheck "unit")
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
      ps: with ps; [
        packaging
        pyyaml
        cryptography
        pyasn1-modules
        tpm2-pytss
      ]
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
  checkInputs = [
    cmocka
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

  # To be able to use the userspace resource manager, the RUNPATH must
  # explicitly include the tpm2-abrmd shared libraries.
  preFixup =
    let
      rpath = lib.makeLibraryPath (
        (lib.optional abrmdSupport tpm2-abrmd)
        ++ [
          glibc
          libyaml
          openssl
          sqlite
          tpm2-tss
        ]
      );
    in
    ''
      patchelf \
        --set-rpath ${rpath} \
        ${lib.optionalString abrmdSupport "--add-needed ${lib.makeLibraryPath [ tpm2-abrmd ]}/libtss2-tcti-tabrmd.so"} \
        --add-needed ${lib.makeLibraryPath [ tpm2-tss ]}/libtss2-tcti-device.so \
        $out/lib/libtpm2_pkcs11.so.0.0.0
    '';

  postInstall = ''
    mkdir -p $bin/bin/ $bin/share/tpm2_pkcs11/
    mv ./tools/* $bin/share/tpm2_pkcs11/
    makeWrapper $bin/share/tpm2_pkcs11/tpm2_ptool.py $bin/bin/tpm2_ptool \
      --prefix PATH : ${lib.makeBinPath [ tpm2-tools ]}
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
