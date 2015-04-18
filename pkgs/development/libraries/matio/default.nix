{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.2";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "0i8xj4g1gv50y6lj3s8hasjqspaawqbrnc06lrkdghvk6gxx00nv";
  };

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://matio.sourceforge.net/;
  };
}
