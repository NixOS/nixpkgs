{lib, stdenv, fetchurl, gettext, python3}:

stdenv.mkDerivation rec {
  pname = "iso-codes";
  version = "4.6.0";

  src = fetchurl {
    url = "https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/${pname}-${version}/${pname}-${pname}-${version}.tar.bz2";
    sha256 = "sha256-Ivd5538QpTFXP2r6ca/g12IZ0ZW1nduu0z4kiSb9Mxs=";
  };

  patchPhase = ''
    for i in `find . -name \*.py`
    do
        sed -i -e "s|#!/usr/bin/env python|#!${python3}/bin/python|" $i
    done
  '';

  nativeBuildInputs = [ gettext python3 ];

  meta = with lib; {
    homepage = "https://salsa.debian.org/iso-codes-team/iso-codes";
    description = "Various ISO codes packaged as XML files";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
