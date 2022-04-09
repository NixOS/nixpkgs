{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, vala
, gobject-introspection
, glib
, gtk3
, freerdp
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "gtk-frdp";
  version = "unstable-2022-04-07";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "70cd7598cb201d58575445d4361263df9b864e73";
    sha256 = "ZyJoJl0WAwalPSkAQNkwDPnP+zLfMMP+ZdIKu2kdXVI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    freerdp
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      branch = "gtk-frdp-0-1";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gtk-frdp";
    description = "RDP viewer widget for GTK";
    maintainers = teams.gnome.members;
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}
