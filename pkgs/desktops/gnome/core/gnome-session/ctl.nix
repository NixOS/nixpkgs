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
  version = "41.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = version;
    hash = "sha256-aC0tkTf2lgCRlcbFj1FEOVBm3YUuP+8Yz98W3ZjUydg=";
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
