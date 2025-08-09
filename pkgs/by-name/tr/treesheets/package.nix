{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  wrapGAppsHook3,
  makeWrapper,
  wxGTK32,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "treesheets";
  version = "0-unstable-2025-07-01";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "treesheets";
    rev = "e6b973c0131380e8b1171bcb4078657cf27f7e70";
    hash = "sha256-sGRLFvUfVlev5o6zlArPiY18io9qMs2wcW6pL1OJln4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    wxGTK32
  ];

  env.NIX_CFLAGS_COMPILE = "-DPACKAGE_VERSION=\"${
    builtins.replaceStrings [ "unstable-" ] [ "" ] version
  }\"";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/TreeSheets.app $out/Applications
    makeWrapper $out/Applications/TreeSheets.app/Contents/MacOS/TreeSheets $out/bin/TreeSheets
  '';

  passthru = {
    updateScript = unstableGitUpdater {
      hardcodeZeroVersion = true;
    };
  };

  meta = with lib; {
    description = "Free Form Data Organizer";
    mainProgram = "TreeSheets";

    longDescription = ''
      The ultimate replacement for spreadsheets, mind mappers, outliners,
      PIMs, text editors and small databases.

      Suitable for any kind of data organization, such as Todo lists,
      calendars, project management, brainstorming, organizing ideas,
      planning, requirements gathering, presentation of information, etc.
    '';

    homepage = "https://strlen.com/treesheets/";
    maintainers = with maintainers; [ obadz ];
    platforms = platforms.unix;
    license = licenses.zlib;
  };
}
