{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libadwaita
, libcanberra
, libgee
, libhandy
, granite7
, gtk4
, pulseaudio
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sound";
  version = "2.3.3-unstable-2024-05-04";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "c2769e770c85d8b669bac4a7e7da7d9b01d7ebd6";
    sha256 = "sha256-FDy423HXRWp1clQ0f6rVRqMctolE3dUnKVhd8tBfNlI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libadwaita
    libcanberra
    libgee
    pulseaudio
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Sound Plug";
    homepage = "https://github.com/elementary/switchboard-plug-sound";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
