{ fetchFromGitHub
, lib
, stdenvNoCC
, variant ? "macchiato"
}:
let
  pname = "catppuccin-k9s";
  validVariants = [ "latte" "frappe" "macchiato" "mocha" ];
in
lib.checkListOfEnum "${pname}: color variant" validVariants [ variant ]

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "unstable-2023-07-23";


  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "k9s";
    rev = "516f44dd1a6680357cb30d96f7e656b653aa5059";
    hash = "sha256-PtBJRBNbLkj7D2ko7ebpEjbfK9Ywjs7zbE+Y8FQVEfA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp "dist/${variant}.yml" $out

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for k9s";
    homepage = "https://github.com/catppuccin/k9s";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
