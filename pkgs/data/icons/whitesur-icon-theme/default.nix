{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, hicolor-icon-theme
, jdupes
, boldPanelIcons ? false
, blackPanelIcons ? false
, themeVariants ? []
}:

let
  pname = "Whitesur-icon-theme";
in
lib.checkListOfEnum "${pname}: theme variants" [ "default" "purple" "pink" "red" "orange" "yellow" "green" "grey" "nord" "all" ] themeVariants

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "2022-05-11";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-7Bbkjbh6nZdYot0tJMWFuW1Jnl9U4KOLN/n+z92UWh4=";
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
