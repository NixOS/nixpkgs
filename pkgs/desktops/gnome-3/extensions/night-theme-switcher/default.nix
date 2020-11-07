{ stdenv, fetchFromGitLab, glib, gnome3, unzip }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-night-theme-switcher";
  version = "40";

  src = fetchFromGitLab {
    owner = "rmnvgr";
    repo = "nightthemeswitcher-gnome-shell-extension";
    rev = "v${version}";
    sha256 = "0z11y18bgdc0y41hrrzzgi4lagm2cg06x12jgdnary1ycng7xja0";
  };

  buildInputs = [ glib gnome3.gnome-shell unzip ];

  uuid = "nightthemeswitcher@romainvigier.fr";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    unzip build/${uuid}.shell-extension.zip -d $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Automatically change the GTK theme to dark variant when Night Light activates";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jonafato ];
    homepage = "https://gitlab.com/rmnvgr/nightthemeswitcher-gnome-shell-extension/";
  };
}
