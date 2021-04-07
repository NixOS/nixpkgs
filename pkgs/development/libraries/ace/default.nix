{ lib, stdenv, fetchurl, pkg-config, libtool, perl }:

stdenv.mkDerivation rec {
  pname = "ace";
  version = "6.5.11";

  src = fetchurl {
    url = "http://download.dre.vanderbilt.edu/previous_versions/ACE-${version}.tar.bz2";
    sha256 = "0fbbysy6aymys30zh5m2bygs84dwwjnbsdl9ipj1rvfrhq8jbylb";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config libtool ];
  buildInputs = [ perl ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=format-security"
  ];

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

  meta = with lib; {
    description = "ADAPTIVE Communication Environment";
    homepage = "http://www.dre.vanderbilt.edu/~schmidt/ACE.html";
    license = licenses.doc;
    platforms = platforms.linux;
    maintainers = [ maintainers.nico202 ];
  };
}
