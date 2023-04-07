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
  version = "unstable-2023-03-03";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "3f991a22c025cad3016a7aa55988e51884964050";
    sha256 = "jzum4/iU1oSr5t/IrSOLFyZcj38VIL7ooIbfoJZhk+g=";
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
