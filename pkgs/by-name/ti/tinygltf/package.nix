{
  lib,

  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,

  # nativeBuildInputs
  cmake,

  # propagatedBuildInputs
  nlohmann_json,
  stb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinygltf";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qs/7O/nPXpMbn31smMfdd3V9zRbyhAnDyjZwlduseKU=";
  };

  patches = [
    # ref. https://github.com/syoyo/tinygltf/pull/552
    (fetchpatch2 {
      name = "cmake-export-nlohmann_json-dependency.patch";
      url = "https://github.com/nim65s/tinygltf/commit/12aec65d78b6b135b2bbd17290a99f608bf5ebd5.patch?full_index=1";
      hash = "sha256-jN/P6FIlOiOx+UIWcpNbPIUILtKCFm7QSU8r5XcEFy4=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    nlohmann_json
    stb
  ];

  cmakeFlags = [
    (lib.cmakeBool "TINYGLTF_INSTALL_VENDOR" false)
    (lib.cmakeBool "TINYGLTF_USE_CUSTOM_JSON" false) # faster but vibe-coded
    (lib.cmakeBool "TINYGLTF_BUILD_TESTS" finalAttrs.doCheck)
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/syoyo/tinygltf/releases/tag/${finalAttrs.src.tag}";
    description = "Header only C++11 tiny glTF 2.0 library";
    homepage = "https://github.com/syoyo/tinygltf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
