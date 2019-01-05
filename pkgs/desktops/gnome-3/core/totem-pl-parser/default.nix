{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, gmime, libxml2, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  name = "totem-pl-parser-${version}";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/totem-pl-parser/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0k5pnka907invgds48d73c1xx1a366v5dcld3gr2l1dgmjwc9qka";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "totem-pl-parser"; attrPath = "gnome3.totem-pl-parser"; };
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext gobject-introspection ];
  buildInputs = [ gmime libxml2 ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Simple GObject-based library to parse and save a host of playlist formats";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
