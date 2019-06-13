{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, libxml2, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "totem-pl-parser";
  version = "3.26.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "13a45py2j1r9967zgww8kd24bn2fhycd4m3kzr90sxx9l2w03z8f";
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
