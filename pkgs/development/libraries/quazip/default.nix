{ fetchurl, stdenv, zip, zlib, qt }:

stdenv.mkDerivation rec {
  name = "quazip-0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/quazip/${name}.tar.gz";
    sha256 = "1pijy6zn8kdx9m6wrckid24vkgp250hklbpmgrpixiam6l889jbq";
  };

  configurePhase = ''
    runHook preConfigure
    cd quazip && qmake quazip.pro
    runHook postConfigure
  '';

  installFlags = "INSTALL_ROOT=$(out)";

  buildInputs = [ zlib qt ];

  meta = {
    description = "Provides access to ZIP archives from Qt programs";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://quazip.sourceforge.net/;
    platforms = stdenv.lib.platforms.linux;
  };
}
