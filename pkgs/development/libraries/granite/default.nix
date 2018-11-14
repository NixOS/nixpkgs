{ stdenv, fetchFromGitHub, cmake, ninja, vala_0_40, pkgconfig, gobjectIntrospection, gnome3, gtk3, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "granite";
  version = "5.2.0";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1v1yhz6rp616xi417m9r8072s6mpz5i8vkdyj264b73p0lgjwh40";
  };

  cmakeFlags = [
    "-DINTROSPECTION_GIRDIR=share/gir-1.0/"
    "-DINTROSPECTION_TYPELIBDIR=lib/girepository-1.0"
  ];

  nativeBuildInputs = [
    cmake
    gettext
    gobjectIntrospection
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
