{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "material-design-icons";
  version = "7.3.67";

  src = fetchFromGitHub {
    owner = "Templarian";
    repo = "MaterialDesign-Webfont";
    rev = "v${version}";
    sha256 = "sha256-gQT+5MqYo1qUiLJTzlhF5dB5BZMtr34JWn9rMa9MJvQ=";
    sparseCheckout = [ "fonts" ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/fonts/"{eot,truetype,woff,woff2}
    cp fonts/*.eot "$out/share/fonts/eot/"
    cp fonts/*.ttf "$out/share/fonts/truetype/"
    cp fonts/*.woff "$out/share/fonts/woff/"
    cp fonts/*.woff2 "$out/share/fonts/woff2/"

    runHook postInstall
  '';

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
    maintainers = with maintainers; [ vlaci dixslyf ];
  };
}
