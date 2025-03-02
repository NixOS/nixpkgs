{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, gtk3
, glib
, granite
, libgee
, libhandy
, libcanberra-gtk3
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "elementary-notifications";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "notifications";
    rev = version;
    sha256 = "sha256-40STrDpMx1WFaTriJNrvkkbzAM0DeBaPdc8o8URItQI=";
  };

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libcanberra-gtk3
    libgee
    libhandy
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "GTK notification server for Pantheon";
    homepage = "https://github.com/elementary/notifications";
    license = licenses.gpl3Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "io.elementary.notifications";
  };
}
