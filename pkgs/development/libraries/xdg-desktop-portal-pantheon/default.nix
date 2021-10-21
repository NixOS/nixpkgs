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
    rev = "d12f82e6d55ea2f1555441e7f2244363b3383506";
    sha256 = "sha256-vZ4CPyWR5QXS5uFQ1lCZmE4uvfU8IHABWVO1KHFIV5U=";
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
