{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libxmi-1.2";
  
  src = fetchurl {
    url = mirror://gnu/libxmi/libxmi-1.2.tar.gz;
    sha256 = "03d4ikh29l38rl1wavb0icw7m5pp7yilnv7bb2k8qij1dinsymlx";
  };
  
  meta = {
    description = "Library for rasterizing 2-D vector graphics";
    homepage = http://www.gnu.org/software/libxmi/;
    license = "GPLv2";
  };
}
