let
  validThemes = [ "bat" "bottom" "btop" "k9s" "lazygit" ];
in
{ fetchFromGitHub
, lib
, stdenvNoCC
, accent ? "blue"
, variant ? "macchiato"
, themeList ? validThemes
}:
let
  pname = "catppuccin";

  validAccents = [ "rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender" ];
  validVariants = [ "latte" "frappe" "macchiato" "mocha" ];

  selectedSources = map (themeName: builtins.getAttr themeName sources) themeList;
  sources = {
    bat = fetchFromGitHub {
      name = "bat";
      owner = "catppuccin";
      repo = "bat";
      rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
      hash = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
    };

    bottom = fetchFromGitHub {
      name = "bottom";
      owner = "catppuccin";
      repo = "bottom";
      rev = "c0efe9025f62f618a407999d89b04a231ba99c92";
      hash = "sha256-VaHX2I/Gn82wJWzybpWNqU3dPi3206xItOlt0iF6VVQ=";
    };

    btop = fetchFromGitHub {
      name = "btop";
      owner = "catppuccin";
      repo = "btop";
      rev = "1.0.0";
      hash = "sha256-J3UezOQMDdxpflGax0rGBF/XMiKqdqZXuX4KMVGTxFk=";
    };

    k9s = fetchFromGitHub {
      name = "k9s";
      owner = "catppuccin";
      repo = "k9s";
      rev = "516f44dd1a6680357cb30d96f7e656b653aa5059";
      hash = "sha256-PtBJRBNbLkj7D2ko7ebpEjbfK9Ywjs7zbE+Y8FQVEfA=";
    };

    lazygit = fetchFromGitHub {
      name = "lazygit";
      owner = "catppuccin";
      repo = "lazygit";
      rev = "0543c28e8af1a935f8c512ad9451facbcc17d8a8";
      hash = "sha256-OVihY5E+elPKag2H4RyWiSv+MdIqHtfGNM3/1u2ik6U=";
    };
  };
in
lib.checkListOfEnum "${pname}: variant" validVariants [ variant ]
lib.checkListOfEnum "${pname}: accent" validAccents [ accent ]
lib.checkListOfEnum "${pname}: themes" validThemes themeList

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "unstable-2023-10-09";

  srcs = selectedSources;

  unpackPhase = ''
    for s in $selectedSources; do
      b=$(basename $s)
      cp $s ''${b#*-}
    done
  '';

  installPhase = ''
    runHook preInstall

  '' + lib.optionalString (lib.elem "bat" themeList) ''
    mkdir -p $out/bat
    cp "${sources.bat}/Catppuccin-${variant}.tmTheme" "$out/bat/"

  '' + lib.optionalString (lib.elem "btop" themeList) ''
    mkdir -p $out/btop
    cp "${sources.btop}/themes/catppuccin_${variant}.theme" "$out/btop/"

  '' + lib.optionalString (lib.elem "bottom" themeList) ''
    mkdir -p $out/bottom
    cp "${sources.bottom}/themes/${variant}.toml" "$out/bottom/"

  '' + lib.optionalString (lib.elem "k9s" themeList) ''
    mkdir -p $out/k9s
    cp "${sources.k9s}/dist/${variant}.yml" "$out/k9s/"

  '' + lib.optionalString (lib.elem "lazygit" themeList) ''
    mkdir -p $out/lazygit/{themes,themes-mergable}
    cp "${sources.lazygit}/themes/${variant}/${variant}-${accent}.yml" "$out/lazygit/themes/"
    cp "${sources.lazygit}/themes-mergable/${variant}/${variant}-${accent}.yml" "$out/lazygit/themes-mergable/"

  '' + ''
    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel themes";
    homepage = "https://github.com/catppuccin/catppuccin";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.khaneliman ];
  };
}
