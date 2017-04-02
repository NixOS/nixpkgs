{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "roboto-${version}";
  version = "2.136";

  src = fetchurl {
    url = "https://github.com/google/roboto/releases/download/v${version}/roboto-unhinted.zip";
    sha256 = "0yx3q5wbbl1qkxfx1fglzy3rvms98jr8fcfj70vvvz3r3lppv201";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -a *.ttf $out/share/fonts/truetype/
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
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
