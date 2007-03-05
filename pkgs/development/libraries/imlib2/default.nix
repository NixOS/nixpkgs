{stdenv, fetchurl, x11, libjpeg, libtiff, libungif, libpng}:

stdenv.mkDerivation {
  name = "imlib2-1.3.0";
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/enlightenment/imlib2-1.3.0.tar.gz;
    sha256 = "1lrg7haqhmzpdb14cgp9vny5fanlwlyhf5n017v130in297gv1qj";
  };
  buildInputs = [x11 libjpeg libtiff libungif libpng];
}
