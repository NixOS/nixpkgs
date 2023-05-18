{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "gnome-shell-extension-paperwm";
  version = "unstable-2023-04-20";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "1130b663806d6daba1c8355c4b99c287d237e918";
    hash = "sha256-JlamW5DznVZ8G0REqXcxEt/IlHa3GMN184WFpeclhd4=";
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
