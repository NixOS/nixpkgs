{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, substituteAll
, meson
, ninja
, pkg-config
, vala
, libgee
, libgtop
, libhandy
, granite
, gtk3
, switchboard
, fwupd
, appstream
, nixos-artwork
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-about";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-/8K3xSbzlagOT0zHdXNwEERJP88C+H2I6qJHXwdlTS4=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
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
    granite
    gtk3
    libgee
    libgtop
    libhandy
    switchboard
  ];

  patches = [
    # Use NixOS's default wallpaper
    (substituteAll {
      src = ./fix-background-path.patch;
      default_wallpaper = "${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}";
    })
  ];

  meta = with lib; {
    description = "Switchboard About Plug";
    homepage = "https://github.com/elementary/switchboard-plug-about";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
