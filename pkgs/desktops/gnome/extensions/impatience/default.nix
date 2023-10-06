{ lib, stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation {
  pname = "gnome-shell-extension-impatience";
  version = "unstable-2023-04-04";

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gnome-shell-impatience";
    rev = "0f961b860040ba0f7bbb51ebbaece7db29787313";
    hash = "sha256-c15zZC9xc0nq8NdnP0gjayMmnD8GyHFV8oZaD4LyR7w=";
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
