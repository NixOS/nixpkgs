{stdenv, fetchurl, gettext, python3}:

stdenv.mkDerivation rec {
  pname = "iso-codes";
  version = "4.4";

  src = fetchurl {
    url = "https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/${pname}-${version}/${pname}-${pname}-${version}.tar.bz2";
    sha256 = "02x0wcz783ammkdrmrh31wsmww481xbkbz70vf766ivbnn5sfxn6";
  };

  patchPhase = ''
    for i in `find . -name \*.py`
    do
        sed -i -e "s|#!/usr/bin/env python|#!${python3}/bin/python|" $i
    done
  '';

  nativeBuildInputs = [ gettext python3 ];

  meta = with stdenv.lib; {
    homepage = https://salsa.debian.org/iso-codes-team/iso-codes;
    description = "Various ISO codes packaged as XML files";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
