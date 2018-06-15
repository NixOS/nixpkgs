{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra-gtk3, clutter-gtk, intltool, itstool
, libxml2, libgee, libgames-support }:

stdenv.mkDerivation rec {
  name = "gnome-nibbles-${version}";
  version = "3.24.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0ddc1fe03483958dd5513d04f5919ade991902d12da18a4c2d3307f818a5cb4f";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-nibbles"; attrPath = "gnome3.gnome-nibbles"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook intltool itstool libxml2
    librsvg libcanberra-gtk3 clutter-gtk gnome3.defaultIconTheme
    libgee libgames-support
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Nibbles;
    description = "Guide a worm around a maze";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
