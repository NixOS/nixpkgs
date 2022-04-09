{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, pulseaudio
, libcanberra-gtk3
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sound";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-hyBmo9P68XSXRUuLw+baEAetba2QdqOwUti64geH6xc=";
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
    libcanberra-gtk3
    libgee
    pulseaudio
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Sound Plug";
    homepage = "https://github.com/elementary/switchboard-plug-sound";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
