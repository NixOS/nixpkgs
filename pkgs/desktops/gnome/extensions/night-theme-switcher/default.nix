{ lib, stdenv, fetchFromGitLab, glib, gnome, unzip }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-night-theme-switcher";
  version = "50";

  src = fetchFromGitLab {
    owner = "rmnvgr";
    repo = "nightthemeswitcher-gnome-shell-extension";
    rev = "v${version}";
    sha256 = "0rs08kr3wizs1vpkmm6pbcvnn7rz47yrq7vnb1s8d58yda9a850d";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ glib gnome.gnome-shell ];

  passthru = {
    extensionUuid = "nightthemeswitcher@romainvigier.fr";
    extensionPortalSlug = "night-theme-switcher";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    unzip "build/nightthemeswitcher@romainvigier.fr.shell-extension.zip" -d "$out/share/gnome-shell/extensions/nightthemeswitcher@romainvigier.fr"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Automatically change the GTK theme to dark variant when Night Light activates";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonafato ];
    homepage = "https://gitlab.com/rmnvgr/nightthemeswitcher-gnome-shell-extension/";
  };
}
