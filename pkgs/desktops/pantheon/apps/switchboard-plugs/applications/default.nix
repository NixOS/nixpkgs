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
, flatpak
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-applications";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-M9JMrxhMiDC/qrrnPaBm6Kf3CAkxrhGWwJF8jVm2G5c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    flatpak
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
    description = "Switchboard Applications Plug";
    homepage = "https://github.com/elementary/switchboard-plug-applications";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
