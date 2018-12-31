{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "material-design-icons-${version}";
  version = "3.2.89";

  src = fetchFromGitHub {
    owner  = "Templarian";
    repo   = "MaterialDesign-Webfont";
    rev    = "v${version}";
    sha256 = "1rxaiiij96kqncsrlkyp109m36v28cgxild7z04k4jh79fvmhjvn";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/{eot,svg,truetype,woff,woff2}
    cp fonts/*.eot $out/share/fonts/eot/
    cp fonts/*.svg $out/share/fonts/svg/
    cp fonts/*.ttf $out/share/fonts/truetype/
    cp fonts/*.woff $out/share/fonts/woff/
    cp fonts/*.woff2 $out/share/fonts/woff2/
  '';

  meta = with stdenv.lib; {
    description = "3200+ Material Design Icons from the Community";
    longDescription = ''
      Material Design Icons' growing icon collection allows designers and
      developers targeting various platforms to download icons in the format,
      color and size they need for any project.
    '';
    homepage = https://materialdesignicons.com;
    license = with licenses; [
      asl20  # for icons from: https://github.com/google/material-design-icons
      ofl
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ vlaci ];
  };
}
