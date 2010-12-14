{stdenv, fetchurl, gettext, python}:

stdenv.mkDerivation rec {
  name = "iso-codes-3.23";
  src = fetchurl {
    url = "ftp://pkg-isocodes.alioth.debian.org/pub/pkg-isocodes/${name}.tar.bz2";
    sha256 = "0lf9phrdr10biihqswq1qmwk5cz954nwavgbnpm7a5r6vzfzkfbq";
  };
  patchPhase = ''
    for i in `find . -name \*.py`
    do
        sed -i -e "s|#!/usr/bin/env python|#!${python}/bin/python|" $i
    done
  '';
  buildInputs = [ gettext ];

  meta = {
    homepage = http://pkg-isocodes.alioth.debian.org/;
    description = "Various ISO codes packaged as XML files";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
