{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchpatch
, flavour ? [ "frappe" ]
, accents ? [ "blue" ]
, winDecStyles ? [ "modern" ]
}:

let
  validFlavours = [ "mocha" "macchiato" "frappe" "latte" ];
  validAccents = [ "rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender" ];
  validWinDecStyles = [ "modern" "classic" ];

  colorScript = ./color.sh;
in

  lib.checkListOfEnum "Invalid accent, valid accents are ${toString validAccents}" validAccents accents
  lib.checkListOfEnum "Invalid flavour, valid flavours are ${toString validFlavours}" validFlavours flavour
  lib.checkListOfEnum "Invalid window decoration style, valid styles are ${toString validWinDecStyles}" validWinDecStyles winDecStyles

stdenvNoCC.mkDerivation rec {
  pname = "kde";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-w77lzeSisx/PPxctMJKIdRJenq0s8HwR8gLmgNh4SH8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/michaelBelsanti/catppuccin-kde/commit/81a8edb3c24bd6af896c92b5051e09af97d69c51.patch";
      hash = "sha256-cb4/dQ52T+H8UqXEgExblmnMfxwO0Y1BrjMCay/EAkI=";
    })
  ];

  installPhase = ''
    runHook preInstall
    patchShebangs .

    for WINDECSTYLE in ${toString winDecStyles}; do
      for FLAVOUR in ${toString flavour}; do
        for ACCENT in ${toString accents}; do
          source ${colorScript}
          ./install.sh $FLAVOUR $ACCENT $WINDECSTYLE
        done;
      done;
    done;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel theme for KDE";
    homepage = "https://github.com/catppuccin/kde";
    license = licenses.mit;
    maintainers = with maintainers; [ michaelBelsanti ];
  };
}
