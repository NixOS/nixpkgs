{stdenv, fetchurl, gettext, python, xz}:

stdenv.mkDerivation rec {
  name = "iso-codes-3.51";
  src = fetchurl {
    url = "http://pkg-isocodes.alioth.debian.org/downloads/${name}.tar.xz";
    sha256 = "0zyp99l4m8cd6301x8zi3xxhziam6v0ic1h8qxb1l0mcjafzf8jj";
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
