{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, libxml2, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "totem-pl-parser";
  version = "3.26.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1w34hdr09v3wy1cfvzhcmxc6b5p9ngcabgix59iv7hk739anymy1";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext gobject-introspection ];
  buildInputs = [ libxml2 ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Simple GObject-based library to parse and save a host of playlist formats";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
