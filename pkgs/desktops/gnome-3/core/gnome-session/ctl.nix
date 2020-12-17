{ stdenv
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
  version = "3.38.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "c20907fea27fa96568b8375a6756c40d0bfb9e40"; # main
    hash = "sha256-y9/yOH6N8wf93+gPqnqzRzV/lPXYD0M6v7dsLFF8lWo=";
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

  meta = with stdenv.lib; {
    description = "gnome-session-ctl extracted from gnome-session for nixpkgs";
    homepage = "https://github.com/nix-community/gnome-session-ctl";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
