{ lib, stdenv, fetchurl, pkg-config, libtool, perl }:

stdenv.mkDerivation rec {
  pname = "ace";
  version = "7.0.1";

  src = fetchurl {
    url = "https://download.dre.vanderbilt.edu/previous_versions/ACE-${version}.tar.bz2";
    sha256 = "sha256-5nH5a0tBOcGfA07eeh9EjH0vgT3gTRWYHXoeO+QFQjQ=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config libtool ];
  buildInputs = [ perl ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=format-security"
  ];

  postPatch = ''
    patchShebangs ./MPC/prj_install.pl
  '';

  preConfigure = ''
    export INSTALL_PREFIX=$out
    export ACE_ROOT=$(pwd)
    export LD_LIBRARY_PATH="$ACE_ROOT/ace:$ACE_ROOT/lib"
    echo '#include "ace/config-linux.h"' > ace/config.h
    echo 'include $(ACE_ROOT)/include/makeinclude/platform_linux.GNU'\
    > include/makeinclude/platform_macros.GNU
  '';

  meta = with lib; {
    homepage = "https://www.dre.vanderbilt.edu/~schmidt/ACE.html";
    description = "ADAPTIVE Communication Environment";
    license = licenses.doc;
    maintainers = with maintainers; [ nico202 ];
    platforms = platforms.linux;
  };
}
