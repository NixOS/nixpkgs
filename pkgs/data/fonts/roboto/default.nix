{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "roboto-${version}";
  version = "2.135";

  src = fetchurl {
    url = "https://github.com/google/roboto/releases/download/v${version}/roboto-unhinted.zip";
    sha256 = "1ndlh36bcx4mhi58sxfx6ywbib586brh6s5sk3jyji78h1i7j8zr";
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
