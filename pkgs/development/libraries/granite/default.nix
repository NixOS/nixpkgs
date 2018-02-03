{ stdenv, fetchFromGitHub, perl, cmake, vala, pkgconfig, gobjectIntrospection, glib, gtk3, gnome3, gettext }:

stdenv.mkDerivation rec {
  name = "granite-${version}";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "granite";
    rev = version;
    sha256 = "15l8z1jkqhvappnr8jww27lfy3dwqybgsxk5iccyvnvzpjdh2s0h";
  };

  cmakeFlags = "-DINTROSPECTION_GIRDIR=share/gir-1.0/ -DINTROSPECTION_TYPELIBDIR=lib/girepository-1.0";
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [perl cmake vala gobjectIntrospection glib gtk3 gnome3.libgee gettext];

  meta = {
    description = "An extension to GTK+ used by elementary OS";
    longDescription = "An extension to GTK+ that provides several useful widgets and classes to ease application development. Designed for elementary OS.";
    homepage = https://github.com/elementary/granite;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.vozz ];
  };
}
