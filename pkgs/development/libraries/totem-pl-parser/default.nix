{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, libxml2, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "totem-pl-parser";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fhwhrq5p0a8arh3lzk5bfjlkip3rlna9r6ybpi9fid4cpwsr1nk";
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
