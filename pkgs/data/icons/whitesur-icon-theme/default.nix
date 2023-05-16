{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, hicolor-icon-theme
, jdupes
, boldPanelIcons ? false
, blackPanelIcons ? false
, alternativeIcons ? false
, themeVariants ? []
}:

let pname = "Whitesur-icon-theme";
in
lib.checkListOfEnum "${pname}: theme variants" [
  "default"
  "purple"
  "pink"
  "red"
  "orange"
  "yellow"
  "green"
  "grey"
  "nord"
  "all"
] themeVariants

stdenvNoCC.mkDerivation rec {
  inherit pname;
<<<<<<< HEAD
  version = "2023-07-03";
=======
  version = "2023-01-08";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-lq6d3BForrvzEJYeEMQZplvn/p6dPjggTToAU9UcPoM=";
=======
    hash = "sha256-xqKGZPlGl8kNZ4AQYZWAywL+6UxwGzYOZ9WvB85JKZk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ gtk3 jdupes ];

  buildInputs = [ hicolor-icon-theme ];

  # These fixup steps are slow and unnecessary
  dontPatchELF = true;
  dontRewriteSymlinks = true;
  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall

    ./install.sh --dest $out/share/icons \
      --name WhiteSur \
      --theme ${builtins.toString themeVariants} \
      ${lib.optionalString alternativeIcons "--alternative"} \
      ${lib.optionalString boldPanelIcons "--bold"} \
      ${lib.optionalString blackPanelIcons "--black"}

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "MacOS Big Sur style icon theme for Linux desktops";
    homepage = "https://github.com/vinceliuice/WhiteSur-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ icy-thought ];
  };

}
