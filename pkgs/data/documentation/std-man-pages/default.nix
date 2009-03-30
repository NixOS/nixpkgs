{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "std-man-pages-4.2.2";
  
  src = fetchurl {
    # We could use a list of mirrors for gcc.gnu.org
    url = ftp://ftp.irisa.fr/pub/mirrors/gcc.gnu.org/gcc/libstdc++/doxygen/libstdc++-man-4.2.2.tar.bz2;
    sha256 = "1572a5hlrj50gk03aardlrhhila0yjlvhqszl424297ga4g95mk2";
  };

  installPhase = ''
    ensureDir $out/share/man
    cp -R * $out/share/man
  '';

  meta = {
    description = "C++ STD manual pages";
    homepage = http://gcc.gnu.org/;
    license = "GPL/LGPL";
  };
}
