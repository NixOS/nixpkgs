{ stdenvNoCC
, fetchFromGitHub
, lib
, gtk3
, jdupes
, nordzy-themes ? [ "all" ] # Override this to only install selected themes
}:

stdenvNoCC.mkDerivation rec {
  pname = "nordzy-icon-theme";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "alvatip";
    repo = "Nordzy-icon";
    rev = version;
    sha256 = "sha256-ea5OBvZrwH5Wvd7aieI9x3S10E8qcyg99Mh9B5RHkjo=";
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
