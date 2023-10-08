{ fetchFromGitHub
, lib
, stdenvNoCC
, accent ? "blue"
, variant ? "macchiato"
}:
let
  pname = "catppuccin-lazygit";
  validAccents = [ "rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender" ];
  validVariants = [ "latte" "frappe" "macchiato" "mocha" ];
in
lib.checkListOfEnum "${pname}: color variant" validVariants [ variant ]
lib.checkListOfEnum "${pname}: color accent" validAccents [ accent ]

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "unstable-2023-09-19";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "lazygit";
    rev = "0543c28e8af1a935f8c512ad9451facbcc17d8a8";
    hash = "sha256-OVihY5E+elPKag2H4RyWiSv+MdIqHtfGNM3/1u2ik6U=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{themes,themes-mergable}
    cp "themes/${variant}/${variant}-${accent}.yml" $out/themes/
    cp "themes-mergable/${variant}/${variant}-${accent}.yml" $out/themes-mergable/

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for lazygit";
    homepage = "https://github.com/catppuccin/lazygit";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
