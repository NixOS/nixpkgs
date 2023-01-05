{ lib
, stdenvNoCC
, fetchFromGitHub
, inkscape
, xcursorgen
, makeFontsConf
}:

let
  dimensions = {
    palette = [ "Frappe" "Latte" "Macchiato" "Mocha" ];
    color = [ "Blue" "Dark" "Flamingo" "Green" "Lavender" "Light" "Maroon" "Mauve" "Peach" "Pink" "Red" "Rosewater" "Sapphire" "Sky" "Teal" "Yellow" ];
  };
  product = lib.attrsets.cartesianProductOfSets dimensions;
  variantName = { palette, color }: (lib.strings.toLower palette) + color;
  variants = map variantName product;
in
stdenvNoCC.mkDerivation {
  pname = "catppuccin-cursors";
  version = "unstable-2022-08-23";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "cursors";
    rev = "3d3023606939471c45cff7b643bffc5d5d4ff29c";
    sha256 = "1z9cjxxsj3vrmhsw1k05b31zmncz1ksaswc4r1k3vd2mmpigq1nk";
  };

  outputs = variants ++ [ "out" ]; # dummy "out" output to prevent breakage

  outputsToInstall = [];

  nativeBuildInputs = [
    inkscape
    xcursorgen
  ];

  postPatch = ''
    patchShebangs ./build.sh
  '';

  # Make fontconfig stop warning about being unable to load config
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  # Make inkscape stop warning about being unable to create profile directory
  preBuild = ''
    export HOME="$NIX_BUILD_ROOT"
  '';

  installPhase = ''
    runHook preInstall

    for output in $(getAllOutputNames); do
      if [ "$output" != "out" ]; then
        local outputDir="''${!output}"
        local iconsDir="$outputDir"/share/icons

        mkdir -p "$iconsDir"

        # Convert to kebab case with the first letter of each word capitalized
        local variant=$(sed 's/\([A-Z]\)/-\1/g' <<< "$output")
        local variant=''${variant^}

        cp -r dist/Catppuccin-"$variant"-Cursors "$iconsDir"
      fi
    done

    # Needed to prevent breakage
    mkdir -p "$out"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Catppuccin cursor theme based on Volantes";
    homepage = "https://github.com/catppuccin/cursors";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ PlayerNameHere ];
  };
}
