{ lib
, fetchFromGitHub
, stdenvNoCC
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "material-design-icons";
  version = "7.4.47";

  src = fetchFromGitHub {
    owner = "Templarian";
    repo = "MaterialDesign-Webfont";
    rev = "v${version}";
    sha256 = "sha256-7t3i3nPJZ/tRslLBfY+9kXH8TR145GC2hPFYJeMHRL8=";
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

  passthru.updateScript = nix-update-script { };

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
