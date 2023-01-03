{ lib, fetchFromGitHub }:

let
  version = "7.0.96";
in fetchFromGitHub {
  name = "material-design-icons-${version}";
  owner  = "Templarian";
  repo   = "MaterialDesign-Webfont";
  rev    = "v${version}";

  postFetch = ''
    mkdir -p $out/share/fonts/{eot,truetype,woff,woff2}
    mv $out/fonts/*.eot $out/share/fonts/eot/
    mv $out/fonts/*.ttf $out/share/fonts/truetype/
    mv $out/fonts/*.woff $out/share/fonts/woff/
    mv $out/fonts/*.woff2 $out/share/fonts/woff2/
    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';
  sha256 = "sha256-l60LRXLwLh+7Ls3kMTJ5eDTVpVMcqtshMv/ehIk8fCk=";

  meta = with lib; {
    description = "7000+ Material Design Icons from the Community";
    longDescription = ''
      Material Design Icons' growing icon collection allows designers and
      developers targeting various platforms to download icons in the format,
      color and size they need for any project.
    '';
    homepage = "https://materialdesignicons.com";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ vlaci ];
  };
}
