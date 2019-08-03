{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.16";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "0i2g7jqbb4j8xlf1ly7gfpw5zyxmr245qf57v6w0jmwx4rfkvfj7";
  };

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://matio.sourceforge.net/;
  };
}
