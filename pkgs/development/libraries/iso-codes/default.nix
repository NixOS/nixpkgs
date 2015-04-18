{stdenv, fetchurl, gettext, python, xz}:

stdenv.mkDerivation rec {
  name = "iso-codes-3.56";
  src = fetchurl {
    url = "http://pkg-isocodes.alioth.debian.org/downloads/${name}.tar.xz";
    sha256 = "0vnfygd03jg21i7r238n450wy2hp354f3ank0v3k34zchbjydl2m";
  };
  patchPhase = ''
    for i in `find . -name \*.py`
    do
        sed -i -e "s|#!/usr/bin/env python|#!${python}/bin/python|" $i
    done
  '';
  buildInputs = [ gettext ];
  nativeBuildInputs = [ xz ];

  meta = {
    homepage = http://pkg-isocodes.alioth.debian.org/;
    description = "Various ISO codes packaged as XML files";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
