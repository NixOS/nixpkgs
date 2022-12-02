{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, glib
, granite
, gtk3
, libgee
, libgudev
, libwacom
, switchboard
, xorg
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-wacom";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-+E+MTIi2Dvv7TvzYEzudeIqlDcP8VP61eBh/PQz9SWI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libgee
    libgudev
    libwacom
    switchboard
    xorg.libX11
    xorg.libXi
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Wacom Plug";
    homepage = "https://github.com/elementary/switchboard-plug-wacom";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
