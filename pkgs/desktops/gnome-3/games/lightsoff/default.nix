{ stdenv, fetchurl, vala, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, wrapGAppsHook
, gettext, itstool, clutter, clutter-gtk, libxml2, appstream-glib
, meson, ninja, python3 }:

stdenv.mkDerivation rec {
  name = "lightsoff-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/lightsoff/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1cv5pkw0n8k5wb98ihx0z1z615w1wc09y884wk608wy40bgq46wp";
  };

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
    sed -i '/gtk-update-icon-cache/s/^/#/' meson_post_install.py
  '';

  nativeBuildInputs = [
    vala pkgconfig wrapGAppsHook itstool gettext appstream-glib libxml2
    meson ninja python3
  ];
  buildInputs = [ gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg clutter clutter-gtk ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "lightsoff";
      attrPath = "gnome3.lightsoff";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Lightsoff;
    description = "Puzzle game, where the objective is to turn off all of the tiles on the board";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
