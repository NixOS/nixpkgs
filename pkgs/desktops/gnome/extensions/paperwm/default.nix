{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-paperwm";
  version = "44.0.0-beta.1";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YRIaSD22bvzXo/wla178GeXIhvIwW6xLacjAQDC2P40=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/gnome-shell/extensions/paperwm@hedning:matrix.org"
    cp -r . "$out/share/gnome-shell/extensions/paperwm@hedning:matrix.org"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/paperwm/PaperWM";
    description = "Tiled scrollable window management for Gnome Shell";
    changelog = "https://github.com/paperwm/PaperWM/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hedning AndersonTorres ];
    platforms = lib.platforms.all;
  };

  passthru.extensionUuid = "paperwm@hedning:matrix.org";
})
