{ lib, stdenv, fetchurl, libelf, zlib }:

let
  version = "20181024";
  src = fetchurl {
    url = "https://www.prevanders.net/libdwarf-${version}.tar.gz";
    # Upstream displays this hash broken into three parts:
    sha512 = "02f8024bb9959c91a1fe322459f7587a589d096595"
           + "6d643921a173e6f9e0a184db7aef66f0fd2548d669"
           + "5be7f9ee368f1cc8940cea4ddda01ff99d28bbf1fe58";
  };
  meta = {
    homepage = "https://www.prevanders.net/dwarf.html";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21Plus;
  };

in rec {
  libdwarf = stdenv.mkDerivation {
    pname = "libdwarf";
    inherit version;

    configureFlags = [ "--enable-shared" "--disable-nonshared" ];

    preConfigure = ''
      cd libdwarf
    '';
    buildInputs = [ libelf zlib ];

    installPhase = ''
      mkdir -p $out/lib $out/include
      cp libdwarf.so.1 $out/lib
      ln -s libdwarf.so.1 $out/lib/libdwarf.so
      cp libdwarf.h dwarf.h $out/include
    '';

    inherit meta src;
  };

  dwarfdump = stdenv.mkDerivation {
    pname = "dwarfdump";
    inherit version;

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
