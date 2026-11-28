{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  which,
  buildPackages,
  libxcrypt-legacy,
  libiconv,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableMinimal ? false,
  extraConfig ? "",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "toybox";
  version = "0.8.15";

  src = fetchFromGitHub {
    owner = "landley";
    repo = "toybox";
    tag = finalAttrs.version;
    hash = "sha256-eZz8s0+jUMGZ3QJ4vX3nXGl+JFJhqfvxDaNJQ8RTHLk=";
  };

  patches = [
    # fix darwin build
    (fetchpatch2 {
      name = "macos-drop-readahead.patch";
      url = "https://github.com/landley/toybox/commit/6a0c0ef5eeb2c43e4feef9781398c1718b8bddcb.patch";
      hash = "sha256-KSHWHmLXSieyTHshTbYbTOi/DW27X+iAQnxes7uszwQ=";
    })
  ];

  depsBuildBuild = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    buildPackages.stdenv.cc
  ];
  buildInputs = [
    libxcrypt-legacy
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ]
  ++ lib.optionals (enableStatic && stdenv.cc.libc ? static) [
    stdenv.cc.libc
    stdenv.cc.libc.static
  ];

  postPatch = ''
    patchShebangs .

    # the tar tests need the "sys" group to exist
    rm tests/tar.test

    # modify/skip tests that try to use setuid/setgid
    substituteInPlace tests/chmod.test \
      --replace-fail '[ "$(uname)" == Darwin ] && ' ""
    substituteInPlace tests/install.test \
      --replace-fail '2750' '750'
  ''
  + lib.optionalString enableStatic ''
    # static sed builds don't handle null bytes properly
    rm tests/sed.test
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # can't read /etc/ in the Darwin sandbox
    sed -i -e '145,146d' tests/find.test
  '';

  inherit extraConfig;

  configurePhase = ''
    runHook preConfigure

    make ${
      if enableMinimal then
        "allnoconfig"
      else if stdenv.hostPlatform.isFreeBSD then
        "freebsd_defconfig"
      else if stdenv.hostPlatform.isDarwin then
        "macos_defconfig"
      else
        "defconfig"
    }

    printf "%s" "$extraConfig" > .config-
    cat .config >> .config-
    mv .config- .config

    make oldconfig

    runHook postConfigure
  '';

  hardeningDisable = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isStatic) [
    # breaks string.h header in musl
    "fortify"
  ];

  makeFlags = [
    "PREFIX=$(out)/bin"
    "CC=${stdenv.cc.targetPrefix}cc"
  ]
  ++ lib.optionals (enableStatic && !stdenv.hostPlatform.isDarwin) [
    "LDFLAGS=--static"
  ];

  installTargets = [ "install_flat" ];

  __darwinAllowLocalNetworking = finalAttrs.finalPackage.doCheck;

  doCheck = true;
  nativeCheckInputs = [ which ]; # used for tests with checkFlags = [ "DEBUG=true" ];
  checkTarget = "tests";
  preCheck = ''
    export USER=$(id -un)
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error -Wno-unused-result -Wno-discarded-qualifiers";

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Lightweight implementation of some Unix command line utilities";
    homepage = "https://landley.net/toybox/";
    license = lib.licenses.bsd0;
    platforms = with lib.platforms; linux ++ darwin ++ freebsd;
    maintainers = with lib.maintainers; [
      hhm
      coolcuber
    ];
    priority = 10;
  };
})
