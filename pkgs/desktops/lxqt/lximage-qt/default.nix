{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, qtbase
, qttools
, qtx11extras
, qtsvg
, qtimageformats
, xorg
, lxqt-build-tools
, libfm-qt
, libexif
, menu-cache
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lximage-qt";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "QvQ0LBGP9XD7vwuUD+A1x8oGDvqTeCkYyd2XyjU0fUo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    qtimageformats # add-on module to support more image file formats
    libfm-qt
    xorg.libpthreadstubs
    xorg.libXdmcp
    libexif
    menu-cache
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lximage-qt";
    description = "The image viewer and screenshot tool for lxqt";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
