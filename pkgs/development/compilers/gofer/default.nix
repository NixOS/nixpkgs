{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "gofer";
  version = "2.30b";

  enableParallelBuilding = true;

  makeFlags = [ "CFLAGS=-O2" ];

  unpackPhase = ''
    mkdir -p gofer
    cd gofer
    unpackFile $src
  '';

  patchPhase = ''
    substituteInPlace prelude.h --replace 'malloc.h' 'stdlib.h'
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib
    # cp $src/standard.prelude $out/lib
    install -Dm755 gofc goferc -t $out/bin
  '';

  fixupPhase = ''
    substituteInPlace $out/bin/goferc \
      --replace '/home/staff/ian/gofer/lib/' '$out/lib/'
      --replace '/usr/local/lib/Gofer/' $out/bin/
  '';

  hardeningDisable = [ "format" ];

  src = fetchurl {
    url = "http://web.cecs.pdx.edu/\~mpj/goferarc/gofer${builtins.replaceStrings [ "." ] [ "" ] version}.tar.gz";
    sha256 = "1lfggpchx4v7adlgn2d02f4ywx8dijr5lzp0w619slprxi0pxfbz";
  };

  meta = with lib; {
    description = "Compiler for Gofer -- a language based on the Haskell report version 1.2";
    homepage = "http://web.cecs.pdx.edu/~mpj/goferarc/";
    license = licenses.unfree;
    maintainers = with maintainers; [ siraben ];
  };
}
