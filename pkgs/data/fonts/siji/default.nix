{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "siji-${date}";
  date = "2016-05-13";

  src = fetchFromGitHub {
    owner = "stark";
    repo = "siji";
    rev = "95369afac3e661cb6d3329ade5219992c88688c1";
    sha256 = "1408g4nxwdd682vjqpmgv0cp0bfnzzzwls62cjs9zrds16xa9dpf";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/pcf
    cp -v */*.pcf $out/share/fonts/pcf
  '';

  meta = {
    homepage = https://github.com/stark/siji;
    description = "An iconic bitmap font based on Stlarch with additional glyphs";
    liscense = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.asymmetric ];
  };
}
