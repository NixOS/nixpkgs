{ stdenv, fetchurl, libelf }:

stdenv.mkDerivation rec {
  name = "libdwarf-20161021";

  src = fetchurl {
    url = "http://www.prevanders.net/${name}.tar.gz";
    sha512 = "733523fd5c58f878d65949c1812b2f46b40c4cc3177bc780c703ec71f83675d4b84e81bc1bcca42adf69b5e122562e4ce8e9a8743af29cc6fafe78ed9f8213fd";
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
