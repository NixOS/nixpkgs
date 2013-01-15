{stdenv, fetchurl, gettext, python, xz}:

stdenv.mkDerivation rec {
  name = "iso-codes-3.40";
  src = fetchurl {
    url = "http://pkg-isocodes.alioth.debian.org/downloads/${name}.tar.xz";
    sha256 = "0iph96n8vh4khidxg2zzhmcqnphfzg50agn0lv9cjhmnx0i712pr";
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
