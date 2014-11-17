{ fetchurl, stdenv, zip, zlib, qt }:

stdenv.mkDerivation rec {
  name = "quazip-0.7";

  src = fetchurl {
    url = "mirror://sourceforge/quazip/${name}.tar.gz";
    sha256 = "8af5e7f9bff98b5a2982800a292eae0176c2b41a98a8deab14f4e1cbe07674a4";
  };

  configurePhase = "cd quazip && qmake quazip.pro";

  installFlags = "INSTALL_ROOT=$(out)";

  buildInputs = [ zlib qt ];

  meta = {
    description = "Provides access to ZIP archives from Qt programs";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://quazip.sourceforge.net/;
    platforms = stdenv.lib.platforms.linux;
  };
}
