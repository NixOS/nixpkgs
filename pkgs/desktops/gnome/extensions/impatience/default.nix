{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
}:

stdenv.mkDerivation {
  pname = "gnome-shell-extension-impatience";
  version = "0.5.2-unstable-2025-02-24";

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gnome-shell-impatience";
    rev = "527295a35b352596fed1fc07799f1e0792a77040"; # shows gnome 48 support
    hash = "sha256-9xfZcKJpBttSP2IbGtjo4UxFEnADgQjyV3vx0jSg8nI=";
  };

  buildInputs = [
    glib
  ];

  buildPhase = ''
    runHook preBuild
    make schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r impatience "$out/share/gnome-shell/extensions/impatience@gfxmonk.net"
    runHook postInstall
  '';

  passthru = {
    extensionUuid = "impatience@gfxmonk.net";
    extensionPortalSlug = "impatience";
  };

  meta = with lib; {
    description = "Speed up builtin gnome-shell animations";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      timbertson
      tiramiseb
    ];
    homepage = "http://gfxmonk.net/dist/0install/gnome-shell-impatience.xml";
  };
}
