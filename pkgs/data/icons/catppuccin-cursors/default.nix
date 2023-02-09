{ lib
, stdenvNoCC
, fetchFromGitHub
, unzip
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
stdenvNoCC.mkDerivation rec {
  pname = "catppuccin-cursors";
  version = "0.2.0";
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "cursors";
    rev = "v${version}";
    sha256 = "sha256-TgV5f8+YWR+h61m6WiBMg3aBFnhqShocZBdzZHSyU2c=";
    sparseCheckout = [ "cursors" ];
  };

  nativeBuildInputs = [ unzip ];

  outputs = variants ++ [ "out" ]; # dummy "out" output to prevent breakage

  outputsToInstall = [];

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

        unzip "cursors/Catppuccin-$variant-Cursors.zip" -d "$iconsDir"
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
