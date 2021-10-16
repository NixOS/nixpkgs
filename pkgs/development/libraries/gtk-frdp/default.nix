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
  version = "unstable-2021-10-01";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "9c15c1202ed66fe20334e33d798cc5ebd39917f0";
    sha256 = "2YOLpyd26qWQKvneH4ww2DS8h/ZNYDmfbYIjQDvDMko=";
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
      # The updater tries src.url by default, which does not exist for fetchFromGitHub (fetchurl).
      url = "${meta.homepage}.git";
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
