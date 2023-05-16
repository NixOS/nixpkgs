{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-paperwm";
  version = "44.3.1";
=======
}:

stdenv.mkDerivation {
  pname = "gnome-shell-extension-paperwm";
  version = "unstable-2023-04-20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-oGBnQGtx2ku4cfgZkZ3OdHlVuiYR8hy1eYDWDZP3fn4=";
=======
    rev = "1130b663806d6daba1c8355c4b99c287d237e918";
    hash = "sha256-JlamW5DznVZ8G0REqXcxEt/IlHa3GMN184WFpeclhd4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
<<<<<<< HEAD

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
=======
    mkdir -p "$out/share/gnome-shell/extensions/paperwm@hedning:matrix.org"
    cp -r . "$out/share/gnome-shell/extensions/paperwm@hedning:matrix.org"
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/paperwm/PaperWM";
    description = "Tiled scrollable window management for Gnome Shell";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hedning AndersonTorres ];
    platforms = platforms.all;
  };

  passthru.extensionUuid = "paperwm@hedning:matrix.org";
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
