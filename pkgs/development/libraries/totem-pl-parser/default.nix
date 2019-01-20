{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, gmime, libxml2, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "totem-pl-parser";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0k5pnka907invgds48d73c1xx1a366v5dcld3gr2l1dgmjwc9qka";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
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
