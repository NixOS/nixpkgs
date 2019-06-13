{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.15";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "1kxi15ph68nnbi0s1m8icb0685wg8ql8gj7wnkdk20kzpf3lbgr1";
  };

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://matio.sourceforge.net/;
  };
}
