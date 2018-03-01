{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, gmime, libxml2, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "totem-pl-parser-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/totem-pl-parser/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "f153a53391e9b42fed5cb6ce62322a58e323fde6ec4a54d8ba4d376cf4c1fbcb";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "totem-pl-parser"; attrPath = "gnome3.totem-pl-parser"; };
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext ];
  buildInputs = [ gmime libxml2 libsoup ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Simple GObject-based library to parse and save a host of playlist formats";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
