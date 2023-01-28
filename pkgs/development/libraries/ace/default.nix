{ lib, stdenv, fetchurl, pkg-config, libtool, perl }:

stdenv.mkDerivation rec {
  pname = "ace";
  version = "7.0.10";

  src = fetchurl {
    url = "https://download.dre.vanderbilt.edu/previous_versions/ACE-${version}.tar.bz2";
    sha256 = "sha256-G3H1MBGseD/G9kigS3r9TrwRk8TYi2KC1CueKhtlNzA=";
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
