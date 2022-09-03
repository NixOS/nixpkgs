{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, hicolor-icon-theme
, jdupes
, roundedIcons ? false
, blackPanelIcons ? false
, colorVariants ? []
,
}:
let
  pname = "Fluent-icon-theme";
in
lib.checkListOfEnum "${pname}: available color variants" [
  "standard"
  "green"
  "grey"
  "orange"
  "pink"
  "purple"
  "red"
  "yellow"
  "teal"
  "all"
] colorVariants

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "2022-02-28";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "UMj3qF9lhd9kM7J/3RtG3AiWlBontrowfsFOb3yr0tQ=";
  };

  nativeBuildInputs = [ gtk3 jdupes ];

  buildInputs = [ hicolor-icon-theme ];

  # Unnecessary & slow fixup's
  dontPatchELF = true;
  dontRewriteSymlinks = true;
  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall

    ./install.sh --dest $out/share/icons \
      --name Fluent \
      ${builtins.toString colorVariants} \
      ${lib.optionalString roundedIcons "--round"} \
      ${lib.optionalString blackPanelIcons "--black"}

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fluent icon theme for linux desktops";
    homepage = "https://github.com/vinceliuice/Fluent-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ icy-thought ];
  };
}
