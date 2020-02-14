{ stdenv, fetchurl, pkgconfig, gettext, glib, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-menus";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0x2blzqrapmbsbfzxjcdcpa3vkw9hq5k96h9kvjmy9kl415wcl68";
  };

  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder "out"}/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=${placeholder "out"}/lib/girepository-1.0"
  ];

  nativeBuildInputs = [ pkgconfig gettext ];
  buildInputs = [ glib gobject-introspection ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-menus";
    description = "Library that implements freedesktops's Desktop Menu Specification in GNOME";
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
  };
}
