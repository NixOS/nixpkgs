{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "roboto-${version}";
  version = "2.134";

  src = fetchurl {
    url = "https://github.com/google/roboto/releases/download/v${version}/roboto-unhinted.zip";
    sha256 = "1l033xc2n4754gwakxshh5235cnrnzy7q6zsp5zghn8ib0gdp5rb";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -a * $out/share/fonts/truetype/
  '';

  meta = {
    homepage = https://github.com/google/roboto;
    description = "The Roboto family of fonts";
    longDescription = ''
      Google’s signature family of fonts, the default font on Android and
      Chrome OS, and the recommended font for Google’s visual language,
      Material Design.
    '';
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms = stdenv.lib.platforms.all;
  };
}
