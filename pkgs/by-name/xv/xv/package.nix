{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  xorg,
  libpng,
  libwebp,
  libtiff,
  jasper,
}:

stdenv.mkDerivation rec {
  pname = "xv";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "jasper-software";
    repo = "xv";
    rev = "v${version}";
    sha256 = "sha256-abmMrAxgccECsOi0eIy9/y0haPkUgbOl9wCgISLy5Rs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    xorg.libX11
    xorg.libXt
    libpng
    libwebp
    libtiff
    jasper
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
