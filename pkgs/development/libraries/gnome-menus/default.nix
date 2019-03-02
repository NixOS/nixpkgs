{ stdenv, fetchurl, pkgconfig, glib, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "gnome-menus";
  version = "3.31.90";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0picm8w70rzql21y39rb7y28irgqvbpri1h2qkh55anwc01yy4rx";
  };

  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder ''out''}/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=${placeholder ''out''}/lib/girepository-1.0"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gobject-introspection ];

  meta = {
    homepage = https://www.gnome.org;
    description = "Library that implements freedesktops's Desktop Menu Specification in GNOME";
    platforms = stdenv.lib.platforms.linux;
  };
}
