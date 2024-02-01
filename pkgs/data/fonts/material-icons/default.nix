{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "material-icons";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = version;
    hash = "sha256-wX7UejIYUxXOnrH2WZYku9ljv4ZAlvgk8EEJJHOCCjE=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp font/*.ttf $out/share/fonts/truetype

    mkdir -p $out/share/fonts/opentype
    cp font/*.otf $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    description = "System status icons by Google, featuring material design";
    homepage = "https://material.io/icons";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ mpcsh ];
  };
}
