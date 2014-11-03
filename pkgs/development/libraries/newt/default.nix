{ fetchurl, stdenv, slang, popt }:

stdenv.mkDerivation rec {
  name = "newt-0.52.15";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/n/e/newt/${name}.tar.gz";
    sha256 = "0hg2l0siriq6qrz6mmzr6l7rpl40ay56c8cak87rb2ks7s952qbs";
  };

  patchPhase = ''
    sed -i -e s,/usr/bin/install,install, -e s,-I/usr/include/slang,, Makefile.in po/Makefile
  '';

  buildInputs = [ slang popt ];

  crossAttrs = {
    makeFlags = "CROSS_COMPILE=${stdenv.cross.config}-";
  };

  meta = {
    homepage = https://fedorahosted.org/newt/;
    description = "Library for color text mode, widget based user interfaces";

    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
