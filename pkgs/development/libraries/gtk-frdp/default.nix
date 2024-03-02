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
, fuse3
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "gtk-frdp";
  version = "unstable-2023-09-16";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "62fc62c5ccb7634f0bc87c57a4673877c24c94ed";
    sha256 = "H+ebFWjpmp4Ua22Bd6K3LsxNHqEbtpawnzA5ry8+XFc=";
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
    fuse3
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-DTARGET_OS_IPHONE=0"
    "-DTARGET_OS_WATCH=0"
  ]);

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gtk-frdp";
    description = "RDP viewer widget for GTK";
    maintainers = teams.gnome.members;
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}
