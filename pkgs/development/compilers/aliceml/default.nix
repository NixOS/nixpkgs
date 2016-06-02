{stdenv, gcc, glibc, fetchurl, fetchgit, libtool, autoconf, automake, file, gnumake, which, zsh, m4, pkgconfig, perl, gnome, pango, sqlite, libxml2, zlib, gmp, smlnj }:

stdenv.mkDerivation {
  name = "aliceml-1.4-7d44dc8e";

  src = fetchgit {
    url = "https://github.com/aliceml/aliceml";
    rev = "7d44dc8e4097c6f85888bbf4ff86d51fe05b0a08";
    sha256 = "1xpvia00cpig0i7qvz29sx7xjic6kd472ng722x4rapz8mjnf8bk";
    fetchSubmodules = true;
  };

  gecodeSrc = fetchurl {
    url = http://www.gecode.org/download/gecode-1.3.1.tar.gz;
    sha256 = "0mgc6llbq166jmlq3alvagqsg3730670zvbwwkdgsqklw70v9355";
  };

  buildInputs = [
    stdenv gcc glibc
    libtool gnumake autoconf automake
    file which zsh m4 gnome.gtk zlib gmp
    gnome.libgnomecanvas pango sqlite
    libxml2 pkgconfig perl smlnj
  ];

  makePatch = ./make.patch;
  seamPatch = ./seam.patch;

  phases = [ "unpackPhase" "patchPhase" "configurePhase" "buildPhase" ];

  patchPhase = ''
    sed -i -e "s@wget ..GECODE_URL. -O - | tar xz@tar xf $gecodeSrc@" make/Makefile
    patch -p1 <$makePatch
    patch -p1 <$seamPatch
  '';

  configurePhase = ''
    make -C make setup PREFIX="$out"
  '';

  buildPhase = ''
    gmp="${gmp.dev}" zlib="${zlib.dev}" PATH=$PATH:`pwd`/seam-support/install/bin make -C make all PREFIX="$out"
  '';

  meta = {
    description = "Functional programming language based on Standard ML";
    longDescription = ''
      Alice ML is a functional programming language based on Standard ML,
      extended with rich support for concurrent, distributed, and constraint
      programming.
    '';
    homepage = http://www.ps.uni-saarland.de/alice/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.doublec ];
  };
}
