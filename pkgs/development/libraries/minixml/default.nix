{ stdenv, fetchurl }:

stdenv.mkDerivation  rec {
  name = "mxml-${version}";
  version = "2.9";

  src = fetchurl {
    url = "http://www.msweet.org/files/project3/${name}.tar.gz";
    sha256 = "14pzhlfidj5v1qbxy7a59yn4jz9pnjrs2zwalz228jsq7ijm9vfd";
  };

  meta = with stdenv.lib; {
    description = "A small XML library";
    homepage = http://www.minixml.org;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
