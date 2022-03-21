{ lib
, stdenv
, fetchFromGitLab
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
, libportal-gtk4
, evolution-data-server
, libical
, librest
, json-glib
, itstool
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "gnome-todo";
  version = "unstable-2022-03-11";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-todo";
    rev = "07791399742366b4e3a6897430054d91df4594b4";
    sha256 = "821KgxkkW4T6bdGuttAz9ao/WStM1QEfn4hY/b0d0jI=";
  };

  patches = [
    # fix build race bug https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=257667
    (fetchpatch {
      url = "https://cgit.freebsd.org/ports/plain/deskutils/gnome-todo/files/patch-src_meson.build?id=a4faaf6cf7835014b5f69a337b544ea4ee7f9655";
      sha256 = "sha256:0ihixyq72yhx6njij7bldsqb80x3y217yh6livknlf5r1wr3hakn";
      extraPrefix = "";
      name = "gnome-todo_meson-build.patch";
    })
  ];

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
    libportal-gtk4 # background
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
    updateScript = unstableGitUpdater {
      url = "https://gitlab.gnome.org/GNOME/gnome-todo.git";
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
