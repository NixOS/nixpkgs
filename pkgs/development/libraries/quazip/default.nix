{ fetchurl, stdenv, zip, zlib, qt5 }:

stdenv.mkDerivation rec {
  name = "quazip-0.7";

  src = fetchurl {
    url = "mirror://sourceforge/quazip/${name}.tar.gz";
    sha256 = "8af5e7f9bff98b5a2982800a292eae0176c2b41a98a8deab14f4e1cbe07674a4";
  };

  configurePhase = "cd quazip && qmake quazip.pro";

  installPhase = "INSTALL_ROOT=$out make install";

  buildInputs = [ zlib qt5 ];

  meta = {
    description = "A Qt/C++ wrapper for Gilles Vollant's ZIP/UNZIP C package (minizip). Provides access to ZIP archives from Qt programs using QIODevice API.";
    license = [ "GPLv2+" ];
    homepage = http://quazip.sourceforge.net/;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
