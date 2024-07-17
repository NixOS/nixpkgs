{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  accent ? "Blue",
  variant ? "Frappe",
}:
let
  pname = "catppuccin-kvantum";
in
lib.checkListOfEnum "${pname}: theme accent"
  [
    "Blue"
    "Flamingo"
    "Green"
    "Lavender"
    "Maroon"
    "Mauve"
    "Peach"
    "Pink"
    "Red"
    "Rosewater"
    "Sapphire"
    "Sky"
    "Teal"
    "Yellow"
  ]
  [ accent ]
  lib.checkListOfEnum
  "${pname}: color variant"
  [
    "Latte"
    "Frappe"
    "Macchiato"
    "Mocha"
  ]
  [ variant ]

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "unstable-2022-07-04";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "Kvantum";
      rev = "d1e174c85311de9715aefc1eba4b8efd6b2730fc";
      sha256 = "sha256-IrHo8pnR3u90bq12m7FEXucUF79+iub3I9vgH5h86Lk=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/Kvantum
      cp -a src/Catppuccin-${variant}-${accent} $out/share/Kvantum
      runHook postInstall
    '';

    meta = with lib; {
      description = "Soothing pastel theme for Kvantum";
      homepage = "https://github.com/catppuccin/Kvantum";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bastaynav ];
    };
  }
