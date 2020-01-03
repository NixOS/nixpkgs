{ stdenv, fetchurl, vala, pkgconfig, gtk3, gnome3, gdk-pixbuf, librsvg, wrapGAppsHook
, gettext, itstool, clutter, clutter-gtk, libxml2, appstream-glib
, meson, ninja, python3 }:

stdenv.mkDerivation rec {
  pname = "lightsoff";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/lightsoff/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1yyq0962fv16rab3alq5saf4gpii9xvcfy5vbq85hhhgjpbqrfns";
  };

  nativeBuildInputs = [
    vala pkgconfig wrapGAppsHook itstool gettext appstream-glib libxml2
    meson ninja python3
  ];
  buildInputs = [ gtk3 gnome3.adwaita-icon-theme gdk-pixbuf librsvg clutter clutter-gtk ];

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
