{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, cmake
, qttools
, wrapQtAppsHook
, libisoburn
, ncnn
, opencv
, vulkan-headers
}:

stdenv.mkDerivation rec {
  pname = "deepin-ocr-plugin-manager";
  version = "unstable-2023-07-10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "9b5c9e57c83b5adde383ed404b73f9dcbf5e6a48";
    hash = "sha256-U5lxAKTaQvvlqbqRezPIcBGg+DpF1hZ204Y1+8dt14U=";
  };

  # don't use vendored opencv
  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace "opencv_mobile" "opencv4"
    substituteInPlace src/paddleocr-ncnn/paddleocr.cpp \
      --replace "/usr" "$out"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    ncnn
    opencv
    vulkan-headers
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  meta = with lib; {
    description = "Plugin manager of optical character recognition for DDE";
    homepage = "https://github.com/linuxdeepin/deepin-ocr-plugin-manager";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
