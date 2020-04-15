{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, libxml2, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "totem-pl-parser";
  version = "3.26.5";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "132jihnf51zs98yjkc6jxyqib4f3dawpjm17g4bj4j78y93dww2k";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext gobject-introspection ];
  buildInputs = [ libxml2 ];

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Videos";
    description = "Simple GObject-based library to parse and save a host of playlist formats";
    maintainers = teams.gnome.members;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
