{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
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

  patches = [
    # Introduces a wallpaper meson flag.
    # The wallpapaper path does not exist on NixOS, let's just remove the wallpaper.
    # https://github.com/elementary/switchboard-plug-about/pull/236
    ./add-wallpaper-option.patch
  ];

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

  mesonFlags = [
    # This option is introduced in add-wallpaper-option.patch
    "-Dwallpaper=false"
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
