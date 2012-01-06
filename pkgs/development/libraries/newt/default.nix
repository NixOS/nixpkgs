{ fetchurl, stdenv, slang, popt }:

stdenv.mkDerivation rec {
  name = "newt-0.52.14";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/n/e/newt/${name}.tar.gz";
    sha256 = "13lp815zwldbw917wxmjy90gp608n3zlk4p3ybfqh0x6p9c4y3zp";
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

    license = "LGPLv2";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
