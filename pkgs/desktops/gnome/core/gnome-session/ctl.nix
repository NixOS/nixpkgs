{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, glib
, systemd
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-session-ctl";
  version = "40.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = version;
    hash = "sha256-gvBmLx8Qoj1vPsOwaZsd9+pTDvU5D7uUts7ZT1pXwNo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    systemd
  ];

  meta = with lib; {
    description = "gnome-session-ctl extracted from gnome-session for nixpkgs";
    homepage = "https://github.com/nix-community/gnome-session-ctl";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
