{ stdenv, fetchurl, bash, autoconf, automake, libtool, pkgconfig, libcangjie
, sqlite, python3, cython3
}:

stdenv.mkDerivation rec {
  name = "pycangjie-${version}";
  version = "1.0";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/Cangjians/pycangjie/archive/v${version}.tar.gz";
    sha256 = "1wx0m0chcpgxhj6cdxrwyi8hq05xlbap1ifs0wzb6nkglir0sb4j";
  };

  buildInputs = [
    autoconf automake libtool pkgconfig libcangjie sqlite python3 cython3
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
