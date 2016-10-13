{ stdenv, fetchurl, libelf }:

stdenv.mkDerivation rec {
  name = "libdwarf-20161001";

  src = fetchurl {
    url = "http://www.prevanders.net/${name}.tar.gz";
    sha512 = "2c522ae0b6e2afffd09e2e79562987fd819b197c9bce4900b6a4fd176b5ff229e88c6b755cfbae7831e7160ddeb3bfe2afbf39d756d7e75ec31ace0668554048";
  };

  configureFlags = " --enable-shared --disable-nonshared";

  preConfigure = ''
    cd libdwarf
  '';
  buildInputs = [ libelf ];

  installPhase = ''
    mkdir -p $out/lib $out/include
    cp libdwarf.so $out/lib
    cp libdwarf.h dwarf.h $out/include
  '';

  meta = {
    homepage = http://reality.sgiweb.org/davea/dwarf.html;
    platforms = stdenv.lib.platforms.linux;
  };
}
