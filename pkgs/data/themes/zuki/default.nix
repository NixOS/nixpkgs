{ stdenv, fetchFromGitHub, meson, ninja, sassc, gdk_pixbuf, librsvg, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "zuki-themes";
  version = "3.32-3";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "1al1fb7pqrcdi4g6llz8ka4sc9hsprv2ba0kkc21r6vajs0qp83n";
  };

  nativeBuildInputs = [ meson ninja sassc ];

  buildInputs = [ gdk_pixbuf librsvg gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  meta = with stdenv.lib; {
    description = "Themes for GTK3, gnome-shell and more";
    homepage = https://github.com/lassekongo83/zuki-themes;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
