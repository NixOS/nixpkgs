{ stdenv, fetchurl, x11, libjpeg, libtiff, libungif, libpng, bzip2 }:

stdenv.mkDerivation {
  name = "imlib2-1.4.4";
  
  src = fetchurl {
    url = mirror://sourceforge/enlightenment/imlib2-1.4.4.tar.gz;
    sha256 = "163162aifak8ya17brzqwjlr8ywz40s2s3573js5blcc1g4m5pm4";
  };
  
  buildInputs = [ x11 libjpeg libtiff libungif libpng bzip2 ];
}
