{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation {
  pname = "picat";
  version = "3.0p2";

  src = fetchurl {
    url    = "http://picat-lang.org/download/picat30_2_src.tar.gz";
    sha256 = "0sn4fqj2ryalcndx1df5kx5rzb4pfcrza5ljlg9dkfbqv02xgxkd";
  };

  buildInputs = [ zlib ];

  ARCH = if stdenv.hostPlatform.system == "i686-linux" then "linux32"
         else if stdenv.hostPlatform.system == "x86_64-linux" then "linux64"
         else throw "Unsupported system";

  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

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
    homepage = "http://picat-lang.org/";
    license = stdenv.lib.licenses.mpl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.earldouglas ];
  };
}
