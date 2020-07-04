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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1pz0ird5vyrz1xycfn2vqh628f2mzwrx0psnp4hqdmj1xk9bjkbp";
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
