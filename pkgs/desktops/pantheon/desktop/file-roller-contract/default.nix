{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  substituteAll,
  file-roller,
}:

stdenv.mkDerivation rec {
  pname = "file-roller-contract";
  version = "0-unstable-2021-02-22";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "cf001d84a7e2ddcfbee2cfdb19885798a869833e";
    sha256 = "sha256-jnXq44NiQiSYsvaBF828TklLg9d6z6n+gCZKgbFiERI=";
  };

  patches = [
    (substituteAll {
      src = ./exec-path.patch;
      file_roller = file-roller;
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
      url = "https://github.com/elementary/file-roller-contract.git";
    };
  };

  meta = with lib; {
    description = "Contractor extension for File Roller";
    homepage = "https://github.com/elementary/file-roller-contract";
    license = licenses.gpl3Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
  };
}
