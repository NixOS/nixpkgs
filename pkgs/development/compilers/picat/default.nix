{ stdenv, fetchurl, zlib, gcc7Stdenv }:

gcc7Stdenv.mkDerivation {
  name = "picat-2.7b12";

  src = fetchurl {
    url = http://picat-lang.org/download/picat27b12_src.tar.gz;
    sha256 = "0hqfrgi5qlq3l5wnpxfk8spk9zly13npzaas57fbhsn7sdaksjj6";
  };

  ARCH = if stdenv.hostPlatform.system == "x86_64-linux" then "linux64"
    else if stdenv.hostPlatform.system == "x86_64-darwin" then "mac64"
    else throw "Unsupported system";

  hardeningDisable = [ "format" ];

  buildInputs = [ zlib ];

  buildPhase = ''
    cd emu
    make -f Makefile.$ARCH
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp picat $out/bin/picat
  '';

  meta = {
    description = "Logic-based programming langage";
    longDescription = ''
      Picat is a simple, and yet powerful, logic-based multi-paradigm
      programming language aimed for general-purpose applications.
    '';
    homepage = http://picat-lang.org/;
    license = stdenv.lib.licenses.mpl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.earldouglas ];
  };
}
