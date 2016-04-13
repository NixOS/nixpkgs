{ stdenv, fetchurl, pkgconfig, libtool, perl
}:

stdenv.mkDerivation rec {
  name = "ace-${version}";
  version = "6.3.3";
  src = fetchurl {
    url=http://download.dre.vanderbilt.edu/previous_versions/ACE-6.3.3.tar.bz2;
    sha256 = "124qk205v8rx8p7rfigsargrpxjx3mh4nr99nlyk9csdc9gy8qpk";
  };

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig libtool perl ];

  patchPhase = ''substituteInPlace ./MPC/prj_install.pl \
    --replace /usr/bin/perl "${perl}/bin/perl"'';
  
  preConfigure = ''
    export INSTALL_PREFIX=$out
    export ACE_ROOT=$(pwd)
    export LD_LIBRARY_PATH="$ACE_ROOT/ace:$ACE_ROOT/lib"
    echo '#include "ace/config-linux.h"' > ace/config.h
    echo 'include $(ACE_ROOT)/include/makeinclude/platform_linux.GNU'\
    > include/makeinclude/platform_macros.GNU
  '';

meta = {
    description = "ADAPTIVE Communication Environment";
    homepage = http://www.dre.vanderbilt.edu/~schmidt/ACE.html;
    license = stdenv.lib.licenses.doc;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}

