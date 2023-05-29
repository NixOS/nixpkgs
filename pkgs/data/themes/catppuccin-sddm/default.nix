{ stdenvNoCC
, lib
, fetchFromGitHub
, variant ? "mocha"
}:

let
  pname = "catppuccin-sddm";
  validVariants = [ "latte" "frappe" "macchiato" "mocha" ];
in
lib.checkListOfEnum "${pname}: color variant" validVariants [ variant ]

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "unstable-2022-12-03";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "bde6932e1ae0f8fdda76eff5c81ea8d3b7d653c0";
    hash = "sha256-ceaK/I5lhFz6c+UafQyQVJIzzPxjmsscBgj8130D4dE=";
  };

  sourceRoot = "source/src/catppuccin-${variant}";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sddm/themes/catppuccin-${variant}
    cp * $out/share/sddm/themes/catppuccin-${variant}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel theme for SDDM";
    homepage = "https://github.com/catppuccin/sddm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}
