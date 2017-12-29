{ stdenv, fetchurl, bash, autoconf, automake, libtool, pkgconfig, libcangjie
, sqlite, python, cython
}:

stdenv.mkDerivation rec {
  name = "${python.libPrefix}-pycangjie-${version}";
  version = "1.3_rev_${rev}";
  rev = "361bb413203fd43bab624d98edf6f7d20ce6bfd3";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/Cangjians/pycangjie/archive/${rev}.tar.gz";
    sha256 = "12yi09nyffmn4va7lzk4irw349qzlbxgsnb89dh15cnw0xmrin05";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoconf automake libtool libcangjie sqlite python cython
  ];

  preConfigure = ''
    find . -name '*.sh' -exec sed -e 's@#!/bin/bash@${bash}/bin/bash@' -i '{}' ';'
    sed -i 's@/usr@${libcangjie}@' tests/__init__.py
  '';

  configureScript = "./autogen.sh";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Python wrapper to libcangjie";
    homepage = http://cangjians.github.io/projects/pycangjie/;
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.linquize ];
    platforms = platforms.all;
  };
}
