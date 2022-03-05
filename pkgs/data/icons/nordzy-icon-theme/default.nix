{ stdenvNoCC
, fetchFromGitHub
, lib
, gtk3
, jdupes
, nordzy-themes ? [ "all" ] # Override this to only install selected themes
}:

stdenvNoCC.mkDerivation {
  pname = "nordzy-icon-theme";
  version = "unstable-2022-01-23";

  src = fetchFromGitHub {
    owner = "alvatip";
    repo = "Nordzy-icon";
    rev = "10b9ee80ef5c4cac1d1770d89a6d55046521ea36";
    sha256 = "1b8abhs5gzr2qy407jq818pr67vjky8zn3pa3c8n552ayybblibk";
  };

  # In the post patch phase we should first make sure to patch shebangs.
  postPatch = ''
    patchShebangs install.sh
  '';

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    name= ./install.sh --dest $out/share/icons \
      ${lib.optionalString (nordzy-themes != []) (lib.strings.concatMapStrings (theme: "-t ${theme} ") nordzy-themes)}

    # Replace duplicate files with hardlinks to the first file in each
    # set of duplicates, reducing the installed size in about 87%
    jdupes -L -r $out/share

    runHook postInstall
  '';

  dontFixup = true;

  meta = with lib; {
    description = "Icon theme using the Nord color palette, based on WhiteSur and Numix icon themes";
    homepage = "https://github.com/alvatip/Nordzy-icon";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ alexnortung ];
  };
}
