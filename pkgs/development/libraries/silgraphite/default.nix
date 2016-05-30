{ stdenv, fetchurl, pkgconfig, freetype, libXft, pango, fontconfig }:

stdenv.mkDerivation rec {
  version = "2.3.1";
  name = "silgraphite-2.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/silgraphite/silgraphite/${version}/${name}.tar.gz";
    sha256 = "9b07c6e91108b1fa87411af4a57e25522784cfea0deb79b34ced608444f2ed65";
  };

  buildInputs = [pkgconfig freetype libXft pango fontconfig];

  NIX_CFLAGS_COMPILE = "-I${freetype.dev}/include/freetype2";

  meta = {
    description = "An advanced font engine";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
