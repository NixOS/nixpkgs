{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.12";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "1afqjhc1wbm7g1vry3w30c7dbrxg6n4i482ybgx6l1b5wj0f75c6";
  };

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://matio.sourceforge.net/;
  };
}
