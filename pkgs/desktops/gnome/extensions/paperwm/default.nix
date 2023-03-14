{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "gnome-shell-extension-paperwm";
  version = "unstable-2022-12-14";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "7c0863c944a02d4e8095034403bff6ade3579091";
    hash = "sha256-EN0sWW/NymRNKrApeFnqg8ax7Et4hr0gKZuvMF4kJYU=";
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
}
