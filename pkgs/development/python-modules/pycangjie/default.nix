{ stdenv, fetchurl, file, libtool, pkgconfig, libcangjie, sqlite, python, cython }:

stdenv.mkDerivation rec {
  name = "pycangjie-${version}";
  version = "1.1";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://cangjians.github.io/downloads/pycangjie/cangjie-${version}.tar.xz";
    sha256 = "0vxcr302467lb99j9j9xdw8fh4dm78gydfcgvjjqby40xh9i4fcp";
  };

  buildInputs = [
    file libtool pkgconfig libcangjie sqlite python cython
  ];

  preConfigure = ''
    sed -i 's@/usr/bin/file@${file}/bin/file@' configure
    sed -i 's@/usr@${libcangjie}@' tests/__init__.py
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Python wrapper to libcangjie";
    homepage = http://cangjians.github.io/projects/pycangjie/;
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.linquize ];
    platforms = platforms.all;
  };
}
