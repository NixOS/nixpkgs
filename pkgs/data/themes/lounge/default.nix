{ lib, stdenv, fetchFromGitHub, meson, ninja, sassc, gtk3, gnome-shell, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "lounge-gtk-theme";
  version = "1.24";

  src = fetchFromGitHub {
    owner = "monday15";
    repo = pname;
    rev = version;
    sha256 = "0ima0aa5j296xn4y0d1zj6vcdrdpnihqdidj7bncxzgbnli1vazs";
  };

  nativeBuildInputs = [ meson ninja sassc gtk3 ];

  buildInputs = [ gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  mesonFlags = [
    "-D gnome_version=${lib.versions.majorMinor gnome-shell.version}"
  ];

  postFixup = ''
    gtk-update-icon-cache "$out"/share/icons/Lounge-aux;
  '';

  meta = with lib; {
    description = "Simple and clean GTK theme with vintage scrollbars, inspired by Absolute, based on Adwaita";
    homepage = "https://github.com/monday15/lounge-gtk-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
