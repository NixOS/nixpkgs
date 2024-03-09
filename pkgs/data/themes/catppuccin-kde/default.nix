{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchpatch
, flavour ? "frappe"
, accent ? "blue"
, winDecStyle ? "modern"
}:

let
  validFlavours = [ "mocha" "macchiato" "frappe" "latte" ];
  validAccents = [ "rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender" ];
  validWinDecStyles = [ "modern" "classic" ];

  colorScript = ./color.sh;
in

  lib.throwIfNot (builtins.elem accent validAccents) "Invalid accent ${accent}, valid accents are ${toString validAccents}"
  lib.throwIfNot (builtins.elem flavour validFlavours) "Invalid flavour ${flavour}, valid flavours are ${toString validFlavours}"
  lib.throwIfNot (builtins.elem winDecStyle validWinDecStyles) "Invalid window decoration style ${winDecStyle}, valid styles are ${toString validWinDecStyles}"

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

    WINDECSTYLE='${winDecStyle}'
    FLAVOUR='${flavour}'
    ACCENT='${accent}'
    source '${colorScript}'
    ./install.sh "$FLAVOUR" "$ACCENT" "$WINDECSTYLE"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel theme for KDE";
    homepage = "https://github.com/catppuccin/kde";
    license = licenses.mit;
    maintainers = with maintainers; [ michaelBelsanti ];
  };
}
