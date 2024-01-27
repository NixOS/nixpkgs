{ lib, stdenv, fetchurl, vala, pkg-config, gtk3, gnome, gdk-pixbuf, librsvg, wrapGAppsHook
, gettext, itstool, clutter, clutter-gtk, libxml2, appstream-glib
, meson, ninja, python3 }:

stdenv.mkDerivation rec {
  pname = "lightsoff";
  version = "40.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/lightsoff/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1aziy64g15bm83zfn3ifs20z9yvscdvsxbx132xnq77i0r3qvlxc";
  };

  nativeBuildInputs = [
    vala pkg-config wrapGAppsHook itstool gettext appstream-glib libxml2
    meson ninja python3
  ];
  buildInputs = [ gtk3 gnome.adwaita-icon-theme gdk-pixbuf librsvg clutter clutter-gtk ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "lightsoff";
      attrPath = "gnome.lightsoff";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Lightsoff";
    description = "Puzzle game, where the objective is to turn off all of the tiles on the board";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
