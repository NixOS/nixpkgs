{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, qtbase
, qttools
, qtx11extras
, qtsvg
, xorg
, lxqt-build-tools
, libfm-qt
, libexif
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lximage-qt";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1z2lvfrw9shpvwxva0vf0rk74nj3mmjgxznsgq8r65645fnj5imb";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    libfm-qt
    xorg.libpthreadstubs
    xorg.libXdmcp
    libexif
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "The image viewer and screenshot tool for lxqt";
    homepage = "https://github.com/lxqt/lximage-qt";
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
