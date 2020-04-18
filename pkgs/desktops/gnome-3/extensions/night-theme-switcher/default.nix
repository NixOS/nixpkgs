{ stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-night-theme-switcher";
  version = "19";

  src = fetchFromGitLab {
    owner = "rmnvgr";
    repo = "nightthemeswitcher-gnome-shell-extension";
    rev = "v${version}";
    sha256 = "1ll0yf1skf51wa10mlrajd1dy459w33kx0i3vhfcx2pdk7mw5a3c";
  };

  # makefile tries to do install in home directory using
  # `gnome-extensions install`
  dontBuild = true;

  uuid = "nightthemeswitcher@romainvigier.fr";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r src/ $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "Automatically change the GTK theme to dark variant when Night Light activates";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jonafato ];
    homepage = "https://gitlab.com/rmnvgr/nightthemeswitcher-gnome-shell-extension/";
  };
}
