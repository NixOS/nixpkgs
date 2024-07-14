{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "roboto";
  version = "2.138";

  src = fetchzip {
    url = "https://github.com/google/roboto/releases/download/v${version}/roboto-unhinted.zip";
    stripRoot = false;
    hash = "sha256-ue3PUZinBpcYgSho1Zrw1KHl7gc/GlN1GhWFk6g5QXE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/google/roboto";
    description = "Roboto family of fonts";
    longDescription = ''
      Google’s signature family of fonts, the default font on Android and
      Chrome OS, and the recommended font for Google’s visual language,
      Material Design.
    '';
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
}
