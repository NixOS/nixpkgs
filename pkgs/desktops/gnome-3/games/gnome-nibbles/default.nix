{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra-gtk3, clutter-gtk, intltool, itstool
, libxml2, libgee, libgnome-games-support }:

stdenv.mkDerivation rec {
  name = "gnome-nibbles-${version}";
  version = "3.24.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "19g44cnrb191v50bdvy2qkrfhvyfsahd0kx9hz95x9gkjfn2nn35";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook intltool itstool libxml2 ];
  buildInputs = [
    gtk3 librsvg libcanberra-gtk3 clutter-gtk gnome3.defaultIconTheme
    libgee libgnome-games-support
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-nibbles";
      attrPath = "gnome3.gnome-nibbles";
    };
  };

  meta = with stdenv.lib; {
    description = "Guide a worm around a maze";
    homepage = https://wiki.gnome.org/Apps/Nibbles;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
