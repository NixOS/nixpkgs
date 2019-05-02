{ stdenv, fetchurl, vala, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, wrapGAppsHook
, gettext, itstool, clutter, clutter-gtk, libxml2, appstream-glib
, meson, ninja, python3 }:

stdenv.mkDerivation rec {
  name = "lightsoff-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/lightsoff/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0vc3ibjs9ynnm0gxlhhin7jpnsx22vnn4ygaybxwmv9w2q49cs9f";
  };

  nativeBuildInputs = [
    vala pkgconfig wrapGAppsHook itstool gettext appstream-glib libxml2
    meson ninja python3
  ];
  buildInputs = [ gtk3 gnome3.adwaita-icon-theme gdk_pixbuf librsvg clutter clutter-gtk ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

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
