{
  lib,

  stdenv,
  fetchFromGitHub,
  nix-update-script,

  # nativeBuildInputs
  cmake,

  # propagatedBuildInputs
  nlohmann_json,
  stb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinygltf";
  version = "2.9.6";

  src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3dBxfdXeTbzeQAXaBXFaflLgXYeuOfESdq6V3+0iCXY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    nlohmann_json
    stb
  ];

  cmakeFlags = [
    (lib.cmakeBool "TINYGLTF_INSTALL_VENDOR" false)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Header only C++11 tiny glTF 2.0 library";
    homepage = "https://github.com/syoyo/tinygltf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
