{ lib
, stdenv
, fetchFromGitHub
, unstableGitUpdater
, substituteAll
, gnome-bluetooth
}:

stdenv.mkDerivation rec {
  pname = "gnome-bluetooth-contract";
  version = "unstable-2021-02-22";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "8dcd4d03dc7a7d487980fd8bc95af985dc4fff5c";
    sha256 = "sha256-9eX6j/cvN/CoqrHrh9mZEsUJ8viDWIGxIva1xFwIK7c=";
  };

  patches = [
    (substituteAll {
      src = ./exec-path.patch;
      gnome_bluetooth = gnome-bluetooth;
    })
  ];

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/contractor
    cp *.contract $out/share/contractor/

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/elementary/gnome-bluetooth-contract.git";
    };
  };

  meta = with lib; {
    description = "Contractor extension for GNOME Bluetooth";
    homepage = "https://github.com/elementary/gnome-bluetooth-contract";
    license = licenses.gpl3Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
  };
}
