{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
  nix-update-script,
  ruby,
  rubyPackages,
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
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "ThrowTheSwitch";
    repo = "Unity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g0ubq7RxGQmL1R6vz9RIGJpVWYsgrZhsTWSrL1ySEug=";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
  ];

  mesonFlags = [
    (lib.mesonBool "extension_memory" buildMemory)
    (lib.mesonBool "extension_fixture" buildFixture)
    (lib.mesonBool "support_double" supportDouble)
  ];

  # The meson file does not have the subdir set correctly
  patches = [ ./meson.patch ];

  postPatch = ''
    patchShebangs --build auto
  '';

  # https://github.com/ThrowTheSwitch/Unity/blob/v2.6.1/.github/workflows/main.yml#L20-L35
  doCheck = true;
  nativeCheckInputs = [
    ruby
    rubyPackages.rake
    rubyPackages.rubocop
    rubyPackages.rspec
  ];

  checkPhase = ''
    runHook preCheck

    cd ../test
    rake ci

    # Must do so the meson install hook works
    cd ../build

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unity Unit Testing Framework";
    homepage = "https://www.throwtheswitch.org/unity";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [
      lib.maintainers.i01011001
      lib.maintainers.RossSmyth
    ];
  };
})
