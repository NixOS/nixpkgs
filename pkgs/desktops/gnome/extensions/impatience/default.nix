{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
}:

stdenv.mkDerivation {
  pname = "gnome-shell-extension-impatience";
<<<<<<< HEAD
  version = "0.5.3-unstable-2025-10-06";
=======
  version = "0.5.2-unstable-2025-02-24";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gnome-shell-impatience";
<<<<<<< HEAD
    rev = "593f9cd52ffd7875265e7cfa2d03e0309fec55b1"; # shows gnome 49 support
    hash = "sha256-Slcd47DX1Gdl5H1kkrn19s95eDpftyS2Wn25UpYCjYQ=";
=======
    rev = "527295a35b352596fed1fc07799f1e0792a77040"; # shows gnome 48 support
    hash = "sha256-9xfZcKJpBttSP2IbGtjo4UxFEnADgQjyV3vx0jSg8nI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Speed up builtin gnome-shell animations";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Speed up builtin gnome-shell animations";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      timbertson
      tiramiseb
    ];
    homepage = "http://gfxmonk.net/dist/0install/gnome-shell-impatience.xml";
  };
}
