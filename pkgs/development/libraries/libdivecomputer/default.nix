{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libdivecomputer-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "https://www.libdivecomputer.org/releases/${name}.tar.gz";
    sha256 = "0nm1mcscpxb9dv4p0lidd6rf5xg4vmcbigj6zqxvgn7pwnvpbzm0";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.libdivecomputer.org;
    description = "A cross-platform and open source library for communication with dive computers from various manufacturers";
    maintainers = [ maintainers.mguentner ];
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
