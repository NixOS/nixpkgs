{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
}:

stdenv.mkDerivation {
  pname = "gnome-shell-extension-impatience";
  version = "0.5.3-unstable-2025-10-06";

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gnome-shell-impatience";
    rev = "593f9cd52ffd7875265e7cfa2d03e0309fec55b1"; # shows gnome 49 support
    hash = "sha256-Slcd47DX1Gdl5H1kkrn19s95eDpftyS2Wn25UpYCjYQ=";
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
