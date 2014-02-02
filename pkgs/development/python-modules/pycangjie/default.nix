{ stdenv, autoconf, automake, libtool, fetchurl, bash, pkgconfig, libcangjie, sqlite, python3, cython3 }:

stdenv.mkDerivation rec {
  name = "pycangjie-1.0";

  src = fetchurl {
    url = "https://github.com/Cangjians/pycangjie/archive/v1.0.tar.gz";
    sha256 = "1wx0m0chcpgxhj6cdxrwyi8hq05xlbap1ifs0wzb6nkglir0sb4j";
  };

  buildInputs = [ automake autoconf libtool pkgconfig libcangjie sqlite python3 cython3 ];

  configureScript = "./autogen.sh";

  preConfigure = ''
    find . -name '*.sh' -exec sed -e 's@#!/bin/bash@${bash}/bin/bash@' -i '{}' ';'
    sed -i 's@/usr@${libcangjie}@' tests/__init__.py
  '';

  doCheck = true;

  meta = {
    description = "A Python wrapper to libcangjie";
    longDescription = ''
      pycangjie is a wrapper to libcangjie.
    '';
    homepage = http://cangjians.github.io/projects/pycangjie/;
    license = "LGPLv3+";

    maintainers = [ stdenv.lib.maintainers.linquize ];
    platforms = stdenv.lib.platforms.all;
  };
}
