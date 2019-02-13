{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "std-man-pages-4.4.0";

  src = fetchurl {
    url = mirror://gcc/libstdc++/doxygen/libstdc++-man.4.4.0.tar.bz2;
    sha256 = "0153py77ll759jacq41dp2z2ksr08pdcfic0rwjd6pr84dk89y9v";
  };

  outputDevdoc = "out";

  installPhase = ''
    mkdir -p $out/share/man
    cp -R * $out/share/man
  '';

  meta = {
    description = "C++ STD manual pages";
    homepage = https://gcc.gnu.org/;
    license = "GPL/LGPL";
    platforms = stdenv.lib.platforms.unix;
  };
}
