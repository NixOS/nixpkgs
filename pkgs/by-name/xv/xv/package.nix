{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libxt,
  libx11,
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
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "jasper-software";
    repo = "xv";
    rev = "v${version}";
    sha256 = "sha256-LylTpHTifH/n2vAPlLQooVM3Oox2BJ9eoQYx3USQ/No=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libx11
    libxt
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
