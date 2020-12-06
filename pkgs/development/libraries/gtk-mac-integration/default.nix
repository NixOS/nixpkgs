{ stdenv, fetchFromGitLab, autoreconfHook, pkgconfig, glib, gtk-doc, gtk, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "gtk-mac-integration";
  version = "2.1.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1w0agv4r0daklv5d2f3l0c10krravjq8bj9hsdsrpka48dbnqmap";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig gtk-doc gobject-introspection ];
  buildInputs = [ glib ];
  propagatedBuildInputs = [ gtk ];

  preAutoreconf = ''
    gtkdocize
  '';

  meta = with stdenv.lib; {
    description = "Provides integration for GTK applications into the Mac desktop";
    license = licenses.lgpl21;
    homepage = "https://wiki.gnome.org/Projects/GTK/OSX/Integration";
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.darwin;
  };
}
