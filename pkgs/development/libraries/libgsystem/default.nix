{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk_doc, gobjectIntrospection
, glib, attr, systemd
}:

stdenv.mkDerivation {
  name = "libgsystem-2014.2";

  meta = with stdenv.lib; {
    description = "GIO-based library with Unix/Linux specific API";
    homepage    = "https://wiki.gnome.org/Projects/LibGSystem";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "libgsystem";
    rev = "v2014.2";
    sha256 = "10mqyy94wbmxv9rizwby4dyvqgranjr3hixr5k7fs90lhgbxbkj6";
  };

  nativeBuildInputs = [
    autoreconfHook pkgconfig gtk_doc gobjectIntrospection
  ];

  propagatedBuildInputs = [ glib attr systemd ];

  preAutoreconf = ''
    mkdir m4
  '';
}
