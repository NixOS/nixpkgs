{ stdenv, fetchurl, libelf }:

let
  version = "20170709";
  src = fetchurl {
    url = "http://www.prevanders.net/libdwarf-${version}.tar.gz";
    sha512 = "afff6716ef1af5d8aae2b887f36b9a6547fb576770bc6f630b82725ed1e59cbd"
           + "387779aa729bbd1a5ae026a25ac76aacf64b038cd898b2419a8676f9aa8c59f1";
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
