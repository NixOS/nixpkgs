{ stdenvNoCC
, lib
, fetchFromGitHub
, variant ? "macchiato"
}:

let
  pname = "catppuccin-plymouth";
  validVariants = [ "latte" "frappe" "macchiato" "mocha" ];
in
lib.checkListOfEnum "${pname}: color variant" validVariants [ variant ]

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "unstable-2022-12-10";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "plymouth";
    rev = "d4105cf336599653783c34c4a2d6ca8c93f9281c";
    hash = "sha256-quBSH8hx3gD7y1JNWAKQdTk3CmO4t1kVo4cOGbeWlNE=";
  };

  sourceRoot = "${src.name}/themes/catppuccin-${variant}";

  installPhase = ''
    runHook preInstall

    sed -i 's:\(^ImageDir=\)/usr:\1'"$out"':' catppuccin-${variant}.plymouth
    mkdir -p $out/share/plymouth/themes/catppuccin-${variant}
    cp * $out/share/plymouth/themes/catppuccin-${variant}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel theme for Plymouth";
    homepage = "https://github.com/catppuccin/plymouth";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.spectre256 ];
  };
}
