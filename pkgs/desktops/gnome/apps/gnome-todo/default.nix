{ lib
, stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, gettext
, gnome
, glib
, gtk4
, wayland
, libadwaita
, libpeas
, gnome-online-accounts
, gsettings-desktop-schemas
, libportal
, evolution-data-server
, libical
, librest
, json-glib
, itstool
}:

stdenv.mkDerivation rec {
  pname = "gnome-todo";
  version = "41.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1r94880d4khbjhhfnhaba3y3d4hv2bri82rzfzxn27s5iybpqras";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    python3
    wrapGAppsHook
    itstool
  ];

  buildInputs = [
    glib
    gtk4
    wayland # required by gtk header
    libadwaita
    libpeas
    gnome-online-accounts
    gsettings-desktop-schemas
    gnome.adwaita-icon-theme

    # Plug-ins
    libportal # background
    evolution-data-server # eds
    libical
    librest # todoist
    json-glib # todoist
  ];

  postPatch = ''
    chmod +x build-aux/meson/meson_post_install.py
    patchShebangs build-aux/meson/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "Personal task manager for GNOME";
    homepage = "https://wiki.gnome.org/Apps/Todo";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
