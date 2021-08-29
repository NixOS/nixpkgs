{ lib, fetchFromGitHub }:

let
  pname = "montserrat";
  version = "7.210";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "JulietaUla";
  repo = pname;
  rev = "v${version}";
  sha256 = "sha256-C6T0Iz1rFC+EsKFJRil2jGTMQ4X7wR80E3eORL5qi0U=";

  postFetch = ''
    tar xf $downloadedFile --strip 1
    install -Dm 444 fonts/otf/*.otf -t $out/share/fonts/otf
    install -Dm 444 fonts/ttf/*.ttf -t $out/share/fonts/ttf
    install -Dm 444 fonts/webfonts/*.woff -t $out/share/fonts/woff
    install -Dm 444 fonts/webfonts/*.woff2 -t $out/share/fonts/woff2
  '';

  meta = with lib; {
    description = "A geometric sans serif font with extended latin support (Regular, Alternates, Subrayada)";
    homepage = "https://www.fontspace.com/julieta-ulanovsky/montserrat";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ scolobb jk ];
  };
}
