{ fetchFromGitHub, lib, stdenv, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "openbar";
  version = "unstable-2024-06-17";

  src = fetchFromGitHub {
    owner = "neuromorph";
    repo = "openbar";
    rev = "efb86d5734d1a86f40d4ca7a18f4c0313f8d5743";
    hash = "sha256-q9RzzCtU5whY//Nq7d7iUNYaHaXJGhDgAA+glclOG2I=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/gnome-shell/extensions/openbar@neuromorph"
    cp -a . "$out/share/gnome-shell/extensions/openbar@neuromorph"
    runHook postInstall
  '';

  passthru = {
    extensionUuid = "openbar@neuromorph";
    extensionPortalSlug = "open-bar";
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "A GNOME Shell extension for customizing Gnome Top Bar / Top Panel, menus and more.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ heywoodlh ];
    homepage = "https://github.com/neuromorph/openbar";
  };
}
