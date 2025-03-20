{
  lib,
  stdenv,
  fetchFromGitHub,
  gnome-shell,
}:

stdenv.mkDerivation {
  pname = "gnome-shell-extension-window-corner-preview";
  version = "unstable-2019-04-03";

  src = fetchFromGitHub {
    owner = "medenagan";
    repo = "window-corner-preview";
    rev = "a95bb1389d94474efab7509aac592fb58fff6006";
    sha256 = "03v18j9l0fb64xrg3swf1vcgl0kpgwjlp8ddn068bpvghrsvgfah";
  };

  dontBuild = true;

  passthru = {
    extensionUuid = "window-corner-preview@fabiomereu.it";
    extensionPortalSlug = "window-corner-preview";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r "window-corner-preview@fabiomereu.it" $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "GNOME Shell extension showing a video preview on the corner of the screen";
    license = licenses.mit;
    maintainers = [ ];
    homepage = "https://github.com/medenagan/window-corner-preview";
    broken = lib.versionAtLeast gnome-shell.version "3.32"; # Doesn't support 3.34
  };
}
