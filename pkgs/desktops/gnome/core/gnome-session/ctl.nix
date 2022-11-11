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
  version = "42.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = version;
    hash = "sha256-XGJVmlxqbJ/1frbzn2TI7BJm449xeLk43xMMqFsLYko=";
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
