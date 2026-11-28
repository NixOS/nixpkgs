{
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  glibcLocales,
  lib,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tomlplusplus";
  version = "3.5.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "marzer";
    repo = "tomlplusplus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I10kkBxE5h052ZN2MfZVguk23XCxO/vQCeDkEXAcpto=";
  };

  nativeBuildInputs = [
    meson
    cmake
    ninja
    pkg-config
  ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isGnu [
    glibcLocales
  ];

  mesonFlags = [
    "-Dbuild_tests=${lib.boolToString finalAttrs.finalPackage.doCheck}"
    "-Dbuild_examples=true"
  ];

  # locale tests seem to only work with glibc
  # darwin also fails the following:
  # libc++abi: terminating due to uncaught exception of type std::runtime_error: collate_byname<char>::collate_byname failed to construct for
  doCheck = stdenv.hostPlatform.isGnu;

  passthru = {
    updateScript = nix-update-script { };
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://github.com/marzer/tomlplusplus";
    description = "Header-only TOML config file parser and serializer for C++17";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scrumplex ];
    pkgConfigModules = [ "tomlplusplus" ];
    platforms = lib.platforms.unix;
  };
})
