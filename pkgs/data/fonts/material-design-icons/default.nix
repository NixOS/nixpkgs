{ lib, fetchFromGitHub }:

let
  version = "5.3.45";
in fetchFromGitHub {
  name = "material-design-icons-${version}";
  owner  = "Templarian";
  repo   = "MaterialDesign-Webfont";
  rev    = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/{eot,truetype,woff,woff2}
    cp fonts/*.eot $out/share/fonts/eot/
    cp fonts/*.ttf $out/share/fonts/truetype/
    cp fonts/*.woff $out/share/fonts/woff/
    cp fonts/*.woff2 $out/share/fonts/woff2/
  '';
  sha256 = "1nwha6dbj97ybiwlf69la57l3ibmwgnzs0nr104bfqnqxjs471sx";

  meta = with lib; {
    description = "4600+ Material Design Icons from the Community";
    longDescription = ''
      Material Design Icons' growing icon collection allows designers and
      developers targeting various platforms to download icons in the format,
      color and size they need for any project.
    '';
    homepage = "https://materialdesignicons.com";
    license = with licenses; [
      asl20  # for icons from: https://github.com/google/material-design-icons
      ofl
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ vlaci ];
  };
}
