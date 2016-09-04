{stdenv, fetchurl, indent}:

stdenv.mkDerivation {
  name = "libdwg-0.6";

  src = fetchurl {
    url = mirror://sourceforge/libdwg/libdwg-0.6.tar.bz2;
    sha256 = "0l8ks1x70mkna1q7mzy1fxplinz141bd24qhrm1zkdil74mcsryc";
  };

  nativeBuildInputs = [ indent ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Library reading dwg files";
    homepage = http://libdwg.sourceforge.net/en/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
