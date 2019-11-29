{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-night-theme-switcher";
  version = "2.1";

  src = fetchgit {
    url = "https://git.romainvigier.fr/Romain/nightthemeswitcher-gnome-shell-extension";
    rev = "v${version}";
    sha256 = "1md44vmc83cp35riszhdvysnvl8pmkcpf5j6n4i2b3wwcjwxqwfy";
  };

  makeFlags = [ "GSEXT_DIR_LOCAL=${placeholder "out"}/share/gnome-shell/extensions" ];

  meta = with stdenv.lib; {
    description = "Automatically change the GTK theme to dark variant when Night Light activates";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jonafato ];
    homepage = https://git.romainvigier.fr/Romain/nightthemeswitcher-gnome-shell-extension;
  };
}
