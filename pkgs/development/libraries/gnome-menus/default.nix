{ stdenv, fetchurl, pkgconfig, gettext, glib, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-menus";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0x2blzqrapmbsbfzxjcdcpa3vkw9hq5k96h9kvjmy9kl415wcl68";
  };

  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder ''out''}/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=${placeholder ''out''}/lib/girepository-1.0"
  ];

  nativeBuildInputs = [ pkgconfig gettext ];
  buildInputs = [ glib gobject-introspection ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    homepage = https://www.gnome.org;
    description = "Library that implements freedesktops's Desktop Menu Specification in GNOME";
    platforms = stdenv.lib.platforms.linux;
  };
}
