{ lib
, stdenv
, fetchurl
, meson
, ninja
, vala
, pkg-config
, wrapGAppsHook4
, gobject-introspection
, gettext
, itstool
, libxml2
, python3
, gnome
, glib
, gtk4
, libadwaita
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "gnome-chess";
  version = "42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-chess/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "Eq9Uk6YiBaxrt0VA8KhYQT2okolmo0boVDMLQdc7w5M=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gettext
    itstool
    libxml2
    python3
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-chess";
      attrPath = "gnome.gnome-chess";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Chess";
    description = "Play the classic two-player boardgame of chess";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
