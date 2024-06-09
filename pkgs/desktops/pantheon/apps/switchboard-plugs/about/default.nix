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
, switchboard
, udisks2
, fwupd
, appstream
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-about";
  version = "6.2.0-unstable-2024-05-05";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "1abd84718bf909cc744a1348c3b9d64e1b56db57";
    sha256 = "sha256-iQwbqw/tIEmhlB0Co9pmfD9apMvavMqZM2W6dzRS54E=";
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
