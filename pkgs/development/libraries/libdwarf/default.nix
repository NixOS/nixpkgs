{ stdenv, fetchurl, libelf }:

stdenv.mkDerivation rec {
  name = "libdwarf-20121130";
  
  src = fetchurl {
    url = http://reality.sgiweb.org/davea/libdwarf-20121130.tar.gz;
    sha256 = "1nfdfn5xf3n485pvpb853awyxxnvrg207i0wmrr7bhk8fcxdxbn0";
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
  };
}
