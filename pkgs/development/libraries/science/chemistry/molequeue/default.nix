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
    repo = pname;
    rev = version;
    hash = "sha256-+NoY8YVseFyBbxc3ttFWiQuHQyy1GN8zvV1jGFjmvLg=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [ qttools ];

  # Fix the broken CMake files to use the correct paths
  postInstall = ''
    substituteInPlace $out/lib/cmake/${pname}/MoleQueueConfig.cmake \
      --replace "$out/" ""
  '';

  meta = with lib; {
    description = "Desktop integration of high performance computing resources";
    mainProgram = "molequeue";
    maintainers = with maintainers; [ sheepforce ];
    homepage = "https://github.com/OpenChemistry/molequeue";
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
