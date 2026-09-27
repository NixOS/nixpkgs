{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  glib,
}:

stdenvNoCC.mkDerivation {
  pname = "gnome-shell-extension-impatience";
  version = "0.5.3-unstable-2026-03-11";

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gnome-shell-impatience";
    rev = "f3f145d33d88a46abcfd77f84665bc64b8c0e01c"; # shows gnome 50 support
    hash = "sha256-3ejg1UZcFDakwsx4RCHqLhUtZypP/x/8pbkoQDurdlg=";
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

  meta = {
    description = "Speed up builtin gnome-shell animations";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      timbertson
      tiramiseb
    ];
    homepage = "http://gfxmonk.net/dist/0install/gnome-shell-impatience.xml";
  };
}
