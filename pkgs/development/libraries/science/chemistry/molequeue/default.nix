{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qttools,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "molequeue";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "molequeue";
    rev = version;
    hash = "sha256-+NoY8YVseFyBbxc3ttFWiQuHQyy1GN8zvV1jGFjmvLg=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [ qttools ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.3 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  # Fix the broken CMake files to use the correct paths
  postInstall = ''
    substituteInPlace $out/lib/cmake/molequeue/MoleQueueConfig.cmake \
      --replace "$out/" ""
  '';

  meta = {
    description = "Desktop integration of high performance computing resources";
    mainProgram = "molequeue";
    maintainers = with lib.maintainers; [ sheepforce ];
    homepage = "https://github.com/OpenChemistry/molequeue";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
}
