{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "judy-1.0.5";

  src = fetchurl {
    url = mirror://sourceforge/judy/Judy-1.0.5.tar.gz;
    sha256 = "1sv3990vsx8hrza1mvq3bhvv9m6ff08y4yz7swn6znszz24l0w6j";
  };

  meta = {
    homepage = http://judy.sourceforge.net/;
    license = stdenv.lib.licenses.lgpl21Plus;
    description = "State-of-the-art C library that implements a sparse dynamic array";
  };
}
