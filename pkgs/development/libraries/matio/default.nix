{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.18";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "09gy507zm1gxxyxf5qapzgars51pm16wis7lqqf84kc57ak73baz";
  };

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = "http://matio.sourceforge.net/";
  };
}
