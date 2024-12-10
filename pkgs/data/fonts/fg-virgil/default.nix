{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fg-virgil";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "excalidraw";
    repo = "excalidraw";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j8fT17RkgMQAAS4KsC2+uItT8Z300SZWnLkyo4XI1WY=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m 444 public/Virgil.woff2 -t $out/share/fonts/woff2
    install -D -m 444 public/FG_Virgil.woff2 -t $out/share/fonts/woff2
    install -D -m 444 public/FG_Virgil.ttf -t $out/share/fonts/ttf

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/excalidraw/virgil";
    description = "The font that powers Excalidraw";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ drupol ];
    license = lib.licenses.ofl;
  };
})
