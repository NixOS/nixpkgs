{ lib
, stdenvNoCC
, fetchFromGitHub
, flavour ? [ "frappe" ]
, accents ? [ "blue" ]
, winDecStyles ? [ "modern" ]
}:

let
  validFlavours = [ "mocha" "macchiato" "frappe" "latte" ];
  validAccents = [ "rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender" ];
  validWinDecStyles = [ "modern" "classic" ];

  installScript = ./install.sh;
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

  installPhase = ''
    runHook preInstall

    patchShebangs .
    for WINDECSTYLE in ${toString winDecStyles}; do
      for FLAVOUR in ${toString flavour}; do
        for ACCENT in ${toString accents}; do
          FLAVOUR=$FLAVOUR ACCENT=$ACCENT WINDECSTYLE=$WINDECSTYLE bash ${installScript}
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
