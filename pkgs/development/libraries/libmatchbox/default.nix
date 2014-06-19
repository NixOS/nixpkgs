{ stdenv, fetchurl, libX11, libXext, libpng, libXft, libICE, pango, libjpeg}:

stdenv.mkDerivation rec {
  name = "libmatchbox-1.9";

  buildInputs = [ libXft libICE pango libjpeg ];
  propagatedBuildInputs = [ libX11 libXext libpng ];

  src = fetchurl {
    url = http://matchbox-project.org/sources/libmatchbox/1.9/libmatchbox-1.9.tar.bz2;
    sha256 = "006zdrgs7rgh7dvakjmqsp1q9karq6c5cz4gki2l15fhx0cf40fv";
  };

  meta = {
    description = "Library of the matchbox X window manager";
    homepage = http://matchbox-project.org/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
