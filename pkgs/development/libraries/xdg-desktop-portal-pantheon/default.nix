{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook
, glib
, gtk3
, libhandy
, pantheon
, systemd
, vte
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-pantheon";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "portals";
    rev = version;
    sha256 = "sha256-uPZUeyyn7HZwcBksY6X5s1bpbIRwqdCNfZKnkynVD+8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
    pantheon.granite
    systemd
    vte
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Backend implementation for xdg-desktop-portal for the Pantheon desktop environment";
    homepage = "https://github.com/elementary/portals";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
