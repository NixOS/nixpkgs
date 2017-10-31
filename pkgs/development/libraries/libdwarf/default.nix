{ stdenv, fetchurl, libelf }:

let
  version = "20161124";
  src = fetchurl {
    url = "http://www.prevanders.net/libdwarf-${version}.tar.gz";
    sha512 = "38e480bce5ae8273fd585ec1d8ba94dc3e865a0ef3fcfcf38b5d92fa1ce41f8b"
           + "8c95a7cf8a6e69e7c6f638a3cc56ebbfb37b6317047309725fa17e7929096799";
  };
  meta = {
    homepage = https://www.prevanders.net/dwarf.html;
    platforms = stdenv.lib.platforms.linux;
  };

in rec {
  libdwarf = stdenv.mkDerivation rec {
    name = "libdwarf-${version}";

    configureFlags = [ "--enable-shared" "--disable-nonshared" ];

    preConfigure = ''
      cd libdwarf
    '';
    buildInputs = [ libelf ];

    installPhase = ''
      mkdir -p $out/lib $out/include
      cp libdwarf.so.1 $out/lib
      ln -s libdwarf.so.1 $out/lib/libdwarf.so
      cp libdwarf.h dwarf.h $out/include
    '';

    inherit meta src;
  };

  dwarfdump = stdenv.mkDerivation rec {
    name = "dwarfdump-${version}";

    preConfigure = ''
      cd dwarfdump
    '';

    buildInputs = [ libelf libdwarf ];

    installPhase = ''
      install -m755 -D dwarfdump $out/bin/dwarfdump
    '';

    inherit meta src;
  };
}
