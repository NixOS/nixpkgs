{ stdenv
, fetchurl
, python
, pkgs
, isPy3k
}:

stdenv.mkDerivation rec {
  name = "pyblock-${version}";
  version = "0.53";
  md5_path = "f6d33a8362dee358517d0a9e2ebdd044";

  src = pkgs.fetchurl rec {
    url = "https://src.fedoraproject.org/repo/pkgs/python-pyblock/"
        + "${name}.tar.bz2/${md5_path}/${name}.tar.bz2";
    sha256 = "f6cef88969300a6564498557eeea1d8da58acceae238077852ff261a2cb1d815";
  };

  postPatch = ''
    sed -i -e 's|/usr/include/python|${python}/include/python|' \
           -e 's/-Werror *//' -e 's|/usr/|'"$out"'/|' Makefile
  '';

  buildInputs = [ python pkgs.lvm2 pkgs.dmraid ];

  makeFlags = [
    "USESELINUX=0"
    "SITELIB=$(out)/${python.sitePackages}"
  ];

  meta = with stdenv.lib; {
    homepage = https://www.centos.org/docs/5/html/5.4/Technical_Notes/python-pyblock.html;
    description = "Interface for working with block devices";
    license = licenses.gpl2Plus;
    broken = isPy3k; # doesn't build on python 3, 2018-04-11
  };

}
