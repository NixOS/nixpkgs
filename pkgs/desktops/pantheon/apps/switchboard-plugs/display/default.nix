{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libgee
, libhandy
, granite
, gtk3
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-display";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-d25++3msaS9dg2Rsl7mrAezDn8Lawd3/X0XPH5Zy6Rc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    libhandy
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Displays Plug";
    homepage = "https://github.com/elementary/switchboard-plug-display";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
