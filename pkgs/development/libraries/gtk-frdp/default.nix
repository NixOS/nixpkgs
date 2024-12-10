{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  gobject-introspection,
  glib,
  gtk3,
  freerdp3,
  fuse3,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "gtk-frdp";
  version = "3.37.1-unstable-2024-03-01";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "11e9fcbee8ca5ec70456dd5b616b2560d7f73adc";
    sha256 = "2e/bAZFRTbBU4ZfgMFHiN9JwVm4qXSRtirPvbC3oT5s=";
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
    freerdp3
    fuse3
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };
  };

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.isDarwin [
      "-DTARGET_OS_IPHONE=0"
      "-DTARGET_OS_WATCH=0"
    ]
  );

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gtk-frdp";
    description = "RDP viewer widget for GTK";
    maintainers = teams.gnome.members;
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}
