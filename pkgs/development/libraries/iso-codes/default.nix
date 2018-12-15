{stdenv, fetchurl, gettext, python3}:

stdenv.mkDerivation rec {
  name = "iso-codes-${version}";
  version = "3.79";

  src = fetchurl {
    url = "https://salsa.debian.org/iso-codes-team/iso-codes/uploads/ef8de8bc12e0512d26ed73436a477871/${name}.tar.xz";
    sha256 = "08i8hjy0qjlw9kd9i87jx967ihwh45l2xi55q1aa5265sind7byb";
  };
  patchPhase = ''
    for i in `find . -name \*.py`
    do
        sed -i -e "s|#!/usr/bin/env python|#!${python3}/bin/python|" $i
    done
  '';
  buildInputs = [ gettext python3 ];

  meta = with stdenv.lib; {
    homepage = https://salsa.debian.org/iso-codes-team/iso-codes;
    description = "Various ISO codes packaged as XML files";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
