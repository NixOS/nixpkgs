{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, vala
, glib
, gtk3
, libgnome-games-support
, gnome
, desktop-file-utils
, clutter
, clutter-gtk
, gettext
, itstool
, libxml2
, wrapGAppsHook
, python3
}:

stdenv.mkDerivation rec {
  pname = "swell-foop";
  version = "41.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "JD96VeXnU6UQhu7CVoMg12ktWxWmanI6tZFwXg2O9t0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook
    python3
    itstool
    gettext
    libxml2
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk3
    libgnome-games-support
    clutter
    clutter-gtk
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Swell%20Foop";
    description = "Puzzle game, previously known as Same GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
