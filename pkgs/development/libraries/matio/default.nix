{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.17";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "00644612zhn53j25vj50q73kmjcrsns2lnmy99y2kavhsckmaiay";
  };

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = "http://matio.sourceforge.net/";
  };
}
