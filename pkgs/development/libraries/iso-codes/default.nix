{stdenv, fetchurl, gettext, python, xz}:

stdenv.mkDerivation rec {
  name = "iso-codes-3.49";
  src = fetchurl {
    url = "http://pkg-isocodes.alioth.debian.org/downloads/${name}.tar.xz";
    sha256 = "1ryk5i467p7xxrbrqynb35ci046yj9k9b4d3hfxzass962lz9q04";
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
