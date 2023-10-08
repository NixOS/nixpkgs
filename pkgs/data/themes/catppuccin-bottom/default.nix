{ fetchFromGitHub
, lib
, stdenvNoCC
, variant ? "macchiato"
}:
let
  pname = "catppuccin-bottom";
  validVariants = [ "latte" "frappe" "macchiato" "mocha" ];
in
lib.checkListOfEnum "${pname}: color variant" validVariants [ variant ]

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "unstable-2022-12-29";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "bottom";
    rev = "c0efe9025f62f618a407999d89b04a231ba99c92";
    hash = "sha256-VaHX2I/Gn82wJWzybpWNqU3dPi3206xItOlt0iF6VVQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp "themes/${variant}.toml" $out

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for bottom";
    homepage = "https://github.com/catppuccin/bottom";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
