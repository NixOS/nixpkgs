{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "nanosvg";
  version = "unstable-2022-12-04";

  src = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "9da543e8329fdd81b64eb48742d8ccb09377aed1";
    hash = "sha256-VOiN6583DtzGYPRkl19VG2QvSzl4T9HaynBuNcvZf94=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Simple stupid SVG parser";
    homepage = "https://github.com/memononen/nanosvg";
    license = licenses.zlib;
    platforms = platforms.all;
  };
}
