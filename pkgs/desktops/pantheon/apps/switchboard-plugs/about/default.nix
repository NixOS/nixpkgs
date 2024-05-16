{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libadwaita
, libgee
, libgtop
, libgudev
, granite7
, gtk4
, packagekit
, polkit
, switchboard
, udisks2
, fwupd
, appstream
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-about";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-6b6nuOp4pEufHEmTraSfKpbtPuO3Z9hQJfvKuuyy7as=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    appstream
    fwupd
    granite7
    gtk4
    libadwaita
    libgee
    libgtop
    libgudev
    packagekit
    polkit
    switchboard
    udisks2
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard About Plug";
    homepage = "https://github.com/elementary/switchboard-plug-about";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
