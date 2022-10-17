{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-paperwm";
  version = "38.2";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = finalAttrs.version;
    hash = "sha256-Unhz2+MOygOog6B5sOLtYTpdeodQH+/CMI93gC5nDvI=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
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
})
