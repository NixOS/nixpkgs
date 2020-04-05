{ stdenv, fetchurl, meson, ninja, vala, gobject-introspection, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, gettext, itstool, python3, libxml2, libgnome-games-support, libgee, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "gnome-mines";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mines/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0m53ymxbgr3rb3yv13fzjwqh6shsfr51abkm47rchsy2jryqkzja";
  };

  # gobject-introspection for finding vapi files
  nativeBuildInputs = [
    meson ninja vala gobject-introspection pkgconfig gettext itstool python3
    libxml2 wrapGAppsHook desktop-file-utils
  ];
  buildInputs = [ gtk3 librsvg gnome3.adwaita-icon-theme libgnome-games-support libgee ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-mines";
      attrPath = "gnome3.gnome-mines";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Mines;
    description = "Clear hidden mines from a minefield";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
