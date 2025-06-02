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
  version = "0-unstable-2025-06-02";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "treesheets";
    rev = "1e6604b6257b41ba518907bfa21c24fa8245c46f";
    hash = "sha256-zSZ7tMjG5/kSzHifMSA7Wsypv0/x+Oir6jx0I5Fyk2c=";
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
