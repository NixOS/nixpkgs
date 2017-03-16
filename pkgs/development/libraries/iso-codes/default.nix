{stdenv, fetchurl, gettext, python3, xz}:

stdenv.mkDerivation rec {
  name = "iso-codes-3.74";

  src = fetchurl {
    url = "http://pkg-isocodes.alioth.debian.org/downloads/${name}.tar.xz";
    sha256 = "1vkaxkcx8h8lbg3z3jjfjs1x1rz1l01j6ll46ysza2gym37g7x11";
  };
  patchPhase = ''
    for i in `find . -name \*.py`
    do
        sed -i -e "s|#!/usr/bin/env python|#!${python3}/bin/python|" $i
    done
  '';
  buildInputs = [ gettext python3 ];

  meta = with stdenv.lib; {
    homepage = http://pkg-isocodes.alioth.debian.org/;
    description = "Various ISO codes packaged as XML files";
    maintainers = [ maintainers.urkud ];
    platforms = platforms.all;
  };
}
