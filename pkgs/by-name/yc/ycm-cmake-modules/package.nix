{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ycm-cmake-modules";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "robotology";
    repo = "ycm-cmake-modules";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a4AC3TOjv50cVT0ARM1KFx2Z4ETzR5eDy761tnqkm8A=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = {
    description = "Collection of various useful CMake modules";
    homepage = "https://github.com/robotology/ycm-cmake-modules";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ emaryn ];
  };
})
