{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, substituteAll
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, libhandy
, libxml2
, libgnomekbd
, libxklavier
, ibus
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-keyboard";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1p1l7dx5v1zzz89hhhkm6n3ls7ig4cf2prh1099f1c054qiy9b0y";
  };

  patches = [
    ./0001-Remove-Install-Unlisted-Engines-function.patch
    (substituteAll {
      src = ./fix-paths.patch;
      ibus = ibus;
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    ibus
    libgee
    libgnomekbd
    libhandy
    libxklavier
    switchboard
  ];

  meta = with lib; {
    description = "Switchboard Keyboard Plug";
    homepage = "https://github.com/elementary/switchboard-plug-keyboard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
