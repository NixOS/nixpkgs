{ fetchFromGitHub
, lib
, stdenvNoCC
, variant ? "macchiato"
}:
let
  pname = "catppuccin-bat";
  validVariants = [ "latte" "frappe" "macchiato" "mocha" ];
in
lib.checkListOfEnum "${pname}: color variant" validVariants [ variant ]

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "unstable-2022-11-10";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
    hash = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp "Catppuccin-${variant}.tmTheme" $out

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for bat";
    homepage = "https://github.com/catppuccin/bat";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.khaneliman ];
  };
}
