{ stdenv, fetchFromGitHub, cmake, ninja, vala_0_40, pkgconfig, gobject-introspection, gnome3, gtk3, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "granite";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1zp0pp5v3j8k6ail724p7h5jj2zmznj0a2ybwfw5sspfdw5bfydh";
  };

  cmakeFlags = [
    "-DINTROSPECTION_GIRDIR=share/gir-1.0/"
    "-DINTROSPECTION_TYPELIBDIR=lib/girepository-1.0"
  ];

  nativeBuildInputs = [
    cmake
    gettext
    gobject-introspection
    ninja
    pkgconfig
    vala_0_40 # should be `elementary.vala` when elementary attribute set is merged
  ];

  buildInputs = [
    glib
    gnome3.libgee
    gtk3
  ];

  meta = with stdenv.lib; {
    description = "An extension to GTK+ used by elementary OS";
    longDescription = ''
      Granite is a companion library for GTK+ and GLib. Among other things, it provides complex widgets and convenience functions
      designed for use in apps built for elementary OS.
    '';
    homepage = https://github.com/elementary/granite;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vozz worldofpeace ];
  };
}
