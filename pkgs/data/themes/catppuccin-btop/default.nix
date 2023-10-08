{ fetchFromGitHub
, lib
, stdenvNoCC
, variant ? "macchiato"
}:
let
  pname = "catppuccin-btop";
  validVariants = [ "latte" "frappe" "macchiato" "mocha" ];
in
lib.checkListOfEnum "${pname}: color variant" validVariants [ variant ]

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname;
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = finalAttrs.version;
    hash = "sha256-J3UezOQMDdxpflGax0rGBF/XMiKqdqZXuX4KMVGTxFk=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp "themes/catppuccin_${variant}.theme" $out

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for btop";
    homepage = "https://github.com/catppuccin/btop";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
})
