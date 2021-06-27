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
}:

stdenv.mkDerivation rec {
  pname = "gnome-todo";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "aAl8lvBnXHFCZn0QQ0ToNHLdf8xTj+wKzb9gJrucobE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    python3
    wrapGAppsHook
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

    # https://gitlab.gnome.org/GNOME/gnome-todo/merge_requests/103
    substituteInPlace src/meson.build \
      --replace 'Gtk-3.0' 'Gtk-4.0'
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
