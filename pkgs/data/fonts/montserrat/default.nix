{ lib, fetchFromGitHub }:

let
  pname = "montserrat";
  version = "7.222";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "JulietaUla";
  repo = pname;
  rev = "v${version}";
  sha256 = "sha256-MeNnc1e5X5f0JyaLY6fX22rytHkvL++eM2ygsdlGMv0=";

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
