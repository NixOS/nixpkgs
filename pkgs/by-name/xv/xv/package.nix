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
<<<<<<< HEAD
  libexif,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation rec {
  pname = "xv";
<<<<<<< HEAD
  version = "6.1.0";
=======
  version = "6.0.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jasper-software";
    repo = "xv";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-bq9xEGQRzWZ3/Unu49q6EW9/XSCgpalyXn4l4Mg255g=";
=======
    sha256 = "sha256-5bhLMGdj7HJOsSOFjNO5s3wDA9XbPTwG+g7OSrKMMXk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    libexif
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
