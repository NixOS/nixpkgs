{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "source-serif-pro-1.014";
  src = fetchurl {
    url = "mirror://sourceforge/sourceserifpro.adobe/SourceSerifPro_FontsOnly-1.014.zip";
    sha256 = "1agack195jqq4g2hmga6f9nwg44garii1g3jpbrdlrwr97rwvqsh";
  };

  buildInputs = [ unzip ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    find . -name "*.otf" -exec cp {} $out/share/fonts/opentype \;
  '';

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/adobe/sourceserifpro;
    description = "A set of OpenType fonts to complement Source Sans Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}

