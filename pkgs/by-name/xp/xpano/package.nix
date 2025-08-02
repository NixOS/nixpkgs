{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  opencv,
  SDL2,
  gtk3,
  catch2_3,
  spdlog,
  exiv2,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "xpano";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "krupkat";
    repo = "xpano";
    tag = "v${version}";
    sha256 = "sha256-f2qoBpZ5lPBocPas8KMsY5bSYL20gO+ZHLz2R66qSig=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    opencv
    SDL2
    gtk3
    spdlog
    exiv2
  ];

  checkInputs = [
    catch2_3
  ];

  doCheck = true;

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
    "-DXPANO_INSTALL_DESKTOP_FILES=ON"
  ];

  meta = {
    description = "Panorama stitching tool";
    mainProgram = "Xpano";
    homepage = "https://krupkat.github.io/xpano/";
    changelog = "https://github.com/krupkat/xpano/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ krupkat ];
    platforms = lib.platforms.linux;
  };
}
