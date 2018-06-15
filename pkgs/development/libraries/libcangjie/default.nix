{ stdenv, autoconf, automake, libtool, m4, fetchurl, bash, pkgconfig, sqlite }:

stdenv.mkDerivation rec {
  name = "libcangjie-${version}";
  version = "1.4_rev_${rev}";
  rev = "a73c1d8783f7b6526fd9b2cc44a669ffa5518d3d";

  src = fetchurl {
    url = "https://github.com/Cangjians/libcangjie/archive/${rev}.tar.gz";
    sha256 = "0i5svvcx099fc9hh5dvr3gpb1041v6vn5fnylxy82zjy239114lg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ automake autoconf libtool m4 sqlite ];

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
    license = stdenv.lib.licenses.lgpl3Plus;

    maintainers = [ stdenv.lib.maintainers.linquize ];
    platforms = stdenv.lib.platforms.all;
  };
}
