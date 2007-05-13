{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libexif-0.6.14";

  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/libexif/libexif-0.6.14.tar.bz2;
    sha256 = "0pza5ysvbvvliz7al2i8l3yai64w09xwc6ivy2v5cl7k43almz84";
  };

  patches = [./no-po.patch];
}
