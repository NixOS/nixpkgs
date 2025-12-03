{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  xorg,
  libpng,
  libwebp,
  libtiff,
  libjpeg,
  jasper,
  libxrandr,
  libexif,
}:

stdenv.mkDerivation rec {
  pname = "xv";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "jasper-software";
    repo = "xv";
    rev = "v${version}";
    sha256 = "sha256-bq9xEGQRzWZ3/Unu49q6EW9/XSCgpalyXn4l4Mg255g=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    xorg.libX11
    xorg.libXt
    libpng
    libwebp
    libtiff
    libjpeg
    jasper
    libxrandr
    libexif
  ];

  meta = {
    description = "Classic image viewer and editor for X";
    homepage = "http://www.trilon.com/xv/";
    license = {
      fullName = "XV License";
      url = "https://github.com/jasper-software/xv/blob/main/src/README";
      free = false;
    };
    maintainers = with lib.maintainers; [ galen ];
  };
}
