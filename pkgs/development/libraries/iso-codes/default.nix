{stdenv, fetchurl, gettext, python3}:

stdenv.mkDerivation rec {
  pname = "iso-codes";
  version = "4.5.0";

  src = fetchurl {
    url = "https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/${pname}-${version}/${pname}-${pname}-${version}.tar.bz2";
    sha256 = "17nnyx07q8vbyqsxbvp4m5s2nrc4fxl3dvgbgmkqww2wl4x1fv9y";
  };

  patchPhase = ''
    for i in `find . -name \*.py`
    do
        sed -i -e "s|#!/usr/bin/env python|#!${python3}/bin/python|" $i
    done
  '';

  nativeBuildInputs = [ gettext python3 ];

  meta = with stdenv.lib; {
    homepage = "https://salsa.debian.org/iso-codes-team/iso-codes";
    description = "Various ISO codes packaged as XML files";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
