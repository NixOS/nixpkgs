{ stdenv, fetchFromGitHub, meson, ninja, sassc, gtk3, gnome3, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "lounge-gtk-theme";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "monday15";
    repo = pname;
    rev = version;
    sha256 = "1y1wkfsv2zrxqcqr53lmr9743mvzcy4swi5j6sxmk1aykx6ccs1p";
  };

  nativeBuildInputs = [ meson ninja sassc gtk3 ];

  buildInputs = [ gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  mesonFlags = [
    "-D gnome_version=${stdenv.lib.versions.majorMinor gnome3.gnome-shell.version}"
  ];

  postFixup = ''
    gtk-update-icon-cache "$out"/share/icons/Lounge-aux;
  '';

  meta = with stdenv.lib; {
    description = "Simple and clean GTK theme with vintage scrollbars, inspired by Absolute, based on Adwaita";
    homepage = "https://github.com/monday15/lounge-gtk-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
