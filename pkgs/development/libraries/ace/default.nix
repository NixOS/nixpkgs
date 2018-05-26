{ stdenv, fetchurl, pkgconfig, libtool, perl }:

stdenv.mkDerivation rec {
  name = "ace-${version}";
  version = "6.4.8";

  src = fetchurl {
    url = "http://download.dre.vanderbilt.edu/previous_versions/ACE-${version}.tar.bz2";
    sha256 = "190cyfs2najph2yycyj8abzddwa8s4wx8lx38iv237plwfl2308g";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig libtool ];
  buildInputs = [ perl ];

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

  meta = with stdenv.lib; {
    description = "ADAPTIVE Communication Environment";
    homepage = http://www.dre.vanderbilt.edu/~schmidt/ACE.html;
    license = licenses.doc;
    platforms = platforms.linux;
    maintainers = [ maintainers.nico202 ];
  };
}
