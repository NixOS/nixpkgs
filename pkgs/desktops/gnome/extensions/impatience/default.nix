{ lib, stdenv, fetchFromGitHub, glib }:

<<<<<<< HEAD
stdenv.mkDerivation {
  pname = "gnome-shell-extension-impatience";
  version = "unstable-2023-04-04";
=======
stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-impatience";
  version = "unstable-2022-03-26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gnome-shell-impatience";
<<<<<<< HEAD
    rev = "0f961b860040ba0f7bbb51ebbaece7db29787313";
    hash = "sha256-c15zZC9xc0nq8NdnP0gjayMmnD8GyHFV8oZaD4LyR7w=";
=======
    rev = "cf7c0bb8776af9a16e4ae114df0cc65869fb669d";
    sha256 = "sha256-z/pZxSEFELtg7kueS2i6gN1+VbN0m4mxc34pOCMak5g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    maintainers = with maintainers; [ timbertson tiramiseb ];
    homepage = "http://gfxmonk.net/dist/0install/gnome-shell-impatience.xml";
  };
}
