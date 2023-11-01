{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "buuf-icon-theme";
  version = "3.45";

  src = fetchzip {
    url = "http://buuficontheme.free.fr/buuf3.45.tar.xz";
    hash = "sha256-TrUHW3W4fMR8esirEenKxV+cxnzjC5U0raPfutear+g=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/
    cp -r . $out/share/icons/buuf-icon-theme

    runHook postInstall
  '';

  meta = with lib; {
    description = "A whimsical and unique icon theme adapted for Gnome";
    homepage = "http://buuficontheme.free.fr/";
    platforms = platforms.all;
    license = licenses.cc-by-nc-sa-25;
    maintainers = with maintainers; [ sk4rd ];
  };
}
