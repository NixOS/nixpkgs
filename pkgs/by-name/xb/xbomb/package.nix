{
  lib,
  stdenv,
  fetchurl,
  libX11,
  libXaw,
}:

stdenv.mkDerivation rec {
  pname = "xbomb";
  version = "2.2b";
  src = fetchurl {
    url = "https://www.gedanken.org.uk/software/xbomb/download/xbomb-${version}.tgz";
    sha256 = "0692gjw28qvh8wj9l58scjw6kxj7jdyb3yzgcgs9wcznq11q839m";
  };

  buildInputs = [
    libX11
    libXaw
  ];

  makeFlags = [
    "INSTDIR=${placeholder "out"}"
  ];

  meta = with lib; {
    homepage = "http://www.gedanken.org.uk/software/xbomb/";
    description = "Minesweeper for X11 with various grid sizes and shapes";
    mainProgram = "xbomb";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
