{stdenv, gcc, glibc, fetchurl, fetchgit, libtool, autoconf, automake, file, gnumake, which, zsh, m4, pkgconfig, perl, gnome, pango, sqlite, libxml2, zlib, gmp, smlnj }:

stdenv.mkDerivation {
  name = "aliceml-1.4-493cd356";

  src = fetchgit {
    url = "https://github.com/aliceml/aliceml";
    rev = "493cd3565f0bc3b35790185ec358fb91b7b43037";
    sha256 = "12fbaf0a474e53f40a71f16bf61c52b7ffe044f4d0993e208e69552df3054d45";
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
    gmp="${gmp}" zlib="${zlib}" PATH=$PATH:`pwd`/seam-support/install/bin make -C make all PREFIX="$out"
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
