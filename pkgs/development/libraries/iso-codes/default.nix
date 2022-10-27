{ lib, stdenv, fetchurl, gettext, python3 }:

stdenv.mkDerivation rec {
  pname = "iso-codes";
  version = "4.11.0";

  src = fetchurl {
    url = "https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/v${version}/${pname}-v${version}.tar.gz";
    sha256 = "sha256-QI95nfQTVGj6fKNetrBcQAS+pEPYHKWLibLkgkAagrs=";
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
