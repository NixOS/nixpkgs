{ lib
, stdenv
, fetchFromGitLab
, cmake
, pkg-config
, glib
, gtk4
, libadwaita
, gobject-introspection
, meson
, ninja
, vala
}:

stdenv.mkDerivation rec {
  pname = "libpanel";
  version = "1.0.alpha1";

  # outputs = [ "out" "dev" "devdoc" ];
  # outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    hash = "sha256-jN+NIJxvrAtuH8DN/pdWEmy+/BfXR7Cw2X/MBbLlT/s=";
  };

  nativeBuildInputs = [
    # cmake
    pkg-config
    glib
    meson
    ninja
    vala
  ];

  buildInputs = [
    gtk4
    libadwaita
    gobject-introspection
  ];

  meta = with lib; {
    description = "A dock/panel library for GTK 4";
    homepage = "https://gitlab.gnome.org/GNOME/libpanel";
    license = licenses.lgpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ magnetophon ]);
    platforms = platforms.unix;
  };
}
