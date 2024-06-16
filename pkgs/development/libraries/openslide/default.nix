{ lib, stdenv, fetchFromGitHub, autoreconfHook
, pkg-config, cairo, glib, gdk-pixbuf, libjpeg
, libpng, libtiff, libxml2, openjpeg, sqlite, zlib
}:

stdenv.mkDerivation rec {
  pname = "openslide";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "openslide";
    repo = "openslide";
    rev = "v${version}";
    sha256 = "1g4hhjr4cbx754cwi9wl84k33bkg232w8ajic7aqhzm8x182hszp";
  };

  buildInputs = [ cairo glib gdk-pixbuf libjpeg libpng libtiff libxml2 openjpeg sqlite zlib ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    homepage = "https://openslide.org";
    description = "A C library that provides a simple interface to read whole-slide images";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lromor ];
  };
}
