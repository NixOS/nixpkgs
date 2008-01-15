{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.24";
  src = fetchurl {
    url = mirror://sourceforge/libpng/libpng-1.2.24.tar.bz2;
    sha256 = "0kd0qkakc5zh2inrzw5r0h02761v1s9q223lv7za7iaxyl4byash";
  };
  propagatedBuildInputs = [zlib];
  inherit zlib;
}
