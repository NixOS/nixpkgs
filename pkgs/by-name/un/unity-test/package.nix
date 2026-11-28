{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  meson,
  ninja,
  ruby,
  python3,
  nix-update-script,
  testers,
  iniparser,
  validatePkgConfig,
  # Adds test groups and extra CLI flags.
  buildFixture ? false,
  # Adds the ablilty to track malloc and free calls.
  # Note that if fixtures are enabled, this option is ignored
  # and will always be enabled.
  buildMemory ? buildFixture,
  # Adds double precision floating point assertions
  supportDouble ? false,

}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unity-test";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "ThrowTheSwitch";
    repo = "Unity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9vCVNdu7e1w0AsCwcLOJXI6EXOaO6zG/PmGjcpsCllw=";
  };

  postPatch = ''
    patchShebangs --build auto
  '';

  outputs = [
    "out"
    "dev"
  ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    python3
    validatePkgConfig
  ];

  # For the helper shebangs
  buildInputs = [
    python3
    ruby
  ];

  mesonFlags = [
    (lib.mesonEnable "extension_memory" buildMemory)
    (lib.mesonBool "extension_fixture" buildFixture)
    (lib.mesonBool "support_double" supportDouble)
  ];

  doCheck = true;
  dontUseMesonCheck = true;
  dontUseNinjaCheck = true;

  checkFlags = lib.optionals stdenv.cc.isClang [
    # Will always try gcc without
    "CC=clang"
  ];

  preCheck = ''
    pushd ../test
    foundMakefile=1
  '';

  postCheck = ''
    popd
  '';

  # Various helpers
  postInstall = ''
    mkdir -p "$out/share"
    install -Dm755 ../auto/* -t "$out/share/"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit iniparser;
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
        versionCheck = true;
      };
    };
  };

  meta = {
    description = "Unity Unit Testing Framework";
    homepage = "https://www.throwtheswitch.org/unity";
    changelog = "https://github.com/ThrowTheSwitch/Unity/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    pkgConfigModules = [ "unity" ];
    maintainers = with lib.maintainers; [
      i01011001
      RossSmyth
    ];
  };
})
