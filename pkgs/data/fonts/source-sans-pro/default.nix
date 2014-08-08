{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "source-sans-pro-1.050";
  src = fetchurl {
    url = "mirror://sourceforge/sourcesans.adobe/SourceSansPro_FontsOnly-1.050.zip";
    sha256 = "002z7kx8jxp5pfrilqaxbwbr5yp9fl3zsp0imawmf5wqagpzayf3";
  };

  buildInputs = [ unzip ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    find . -name "*.otf" -exec cp {} $out/share/fonts/opentype \;
  '';

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/adobe/sourcesans;
    description = "A set of OpenType fonts designed by Adobe for UIs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
