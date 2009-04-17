{stdenv, fetchurl, gettext, python}:

stdenv.mkDerivation {
  name = "iso-codes-3.5";
  src = fetchurl {
    url = ftp://pkg-isocodes.alioth.debian.org/pub/pkg-isocodes/iso-codes-3.5.tar.bz2;
    sha256 = "2aac5f37a9ebb5af9c5d186ba1428f05ad779c7760e279cd8b86897a5d434807";
  };
  patchPhase = ''
    for i in `find . -name \*.py`
    do
        sed -i -e "s|#!/usr/bin/env python|#!${python}/bin/python|" $i
    done
  '';
  buildInputs = [ gettext ];
}
