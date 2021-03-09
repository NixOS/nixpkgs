{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, substituteAll
, vala
, libgee
, granite
, gtk3
, networkmanager
, networkmanagerapplet
, libnma
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-network";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-HdLQiGwaw2FPAcLF6M7zGCxtAYid/6woAQGUit2rQaI=";
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
    granite
    gtk3
    libgee
    networkmanager
    libnma
    switchboard
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit networkmanagerapplet;
    })
  ];


  meta = with lib; {
    description = "Switchboard Networking Plug";
    homepage = "https://github.com/elementary/switchboard-plug-network";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
