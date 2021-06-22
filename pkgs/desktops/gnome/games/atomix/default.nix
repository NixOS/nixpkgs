{ lib, stdenv, fetchurl, meson, ninja, pkg-config, wrapGAppsHook, python3
, gettext, gnome, glib, gtk3, libgnome-games-support, gdk-pixbuf }:

stdenv.mkDerivation rec {
  pname = "atomix";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/atomix/${lib.versions.majorMinor version}/atomix-${version}.tar.xz";
    sha256 = "0h909a4mccf160hi0aimyicqhq2b0gk1dmqp7qwf87qghfrw6m00";
  };

  nativeBuildInputs = [ meson ninja pkg-config gettext wrapGAppsHook python3 ];
  buildInputs = [ glib gtk3 gdk-pixbuf libgnome-games-support gnome.adwaita-icon-theme ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "Puzzle game where you move atoms to build a molecule";
    homepage = "https://wiki.gnome.org/Apps/Atomix";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
