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
    description = "Collection of CMake modules for build maintenance";
    homepage = "https://github.com/robotology/ycm-cmake-modules";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ emaryn ];
  };
})
