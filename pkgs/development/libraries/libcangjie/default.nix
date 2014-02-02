{ stdenv, autoconf, automake, libtool, m4, fetchurl, bash, pkgconfig, sqlite }:

stdenv.mkDerivation rec {
  name = "libcangjie-1.0";

  src = fetchurl {
    url = "https://github.com/Cangjians/libcangjie/archive/v1.0.tar.gz";
    sha256 = "15la1pxa2fvhznlbkl32qp2cgd602bvrx2zmahybypbfik0cgqk1";
  };

  buildInputs = [ automake autoconf libtool m4 pkgconfig sqlite ];

  configureScript = "./autogen.sh";
  
  preConfigure = ''
    find . -name '*.sh' -exec sed -e 's@#!/bin/bash@${bash}/bin/bash@' -i '{}' ';'
  '';

  doCheck = true;

  meta = {
    description = "A C library implementing the Cangjie input method";
    longDescription = ''
      libcangjie is a library implementing the Cangjie input method.
    '';
    homepage = http://cangjians.github.io/projects/libcangjie/;
    license = "LGPLv3+";

    maintainers = [ stdenv.lib.maintainers.linquize ];
    platforms = stdenv.lib.platforms.all;
  };
}
