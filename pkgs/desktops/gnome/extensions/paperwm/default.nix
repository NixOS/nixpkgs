{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-paperwm";
  version = "44.3.1";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oGBnQGtx2ku4cfgZkZ3OdHlVuiYR8hy1eYDWDZP3fn4=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/gnome-shell/extensions/paperwm@hedning:matrix.org"
    cp -r . "$out/share/gnome-shell/extensions/paperwm@hedning:matrix.org"

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { url = finalAttrs.meta.homepage; };

  meta = {
    homepage = "https://github.com/paperwm/PaperWM";
    description = "Tiled scrollable window management for Gnome Shell";
    changelog = "https://github.com/paperwm/PaperWM/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hedning AndersonTorres cab404 ];
    platforms = lib.platforms.all;
  };

  passthru.extensionUuid = "paperwm@hedning:matrix.org";
})
