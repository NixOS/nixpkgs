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
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "gtk-frdp";
  version = "3.37.1-unstable-2020-10-26";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "805721e82ca1df6a50da3b5bd3b75d6747016482";
    sha256 = "q/UFKYj3LUkAzll3KeKd6oec0GJnDtTuFMTTatKFlcs=";
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
    updateScript = nix-update-script {
      attrPath = pname;
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
