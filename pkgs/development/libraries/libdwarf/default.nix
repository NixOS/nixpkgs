{ stdenv, fetchurl, libelf }:

stdenv.mkDerivation rec {
  name = "libdwarf-20140805";
  
  src = fetchurl {
    url = "http://www.prevanders.net/${name}.tar.gz";
    sha256 = "1z5xz0w1yvk8swcqzx4dvnig94j51pns39jmipv5rl20qahik0nl";
  };

  configureFlags = "--enable-shared";

  preBuild = ''
    export LD_LIBRARY_PATH=`pwd`/libdwarf
  '';

  buildInputs = [ libelf ];

  installPhase = ''
    mkdir -p $out/lib $out/include $out/bin
    cp ./dwarfdump2/dwarfdump $out/bin/dwarfdump2
    cp ./dwarfdump/dwarfdump $out/bin/dwarfdump
    cp libdwarf/libdwarf.so $out/lib
    cp libdwarf/libdwarf.h libdwarf/dwarf.h $out/include
  '';

  meta = {
    homepage = http://www.prevanders.net/dwarf.html;
    license = stdenv.lib.licenses.gpl2;
  };
}
