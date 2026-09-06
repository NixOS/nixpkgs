{
  lib,
  stdenvNoCC,
  unzip,
  fetchurl,
}:

let

  hashes = lib.importJSON ./hashes.json;

  maple-font =
    {
      pname,
      hash,
      desc,
    }:
    stdenvNoCC.mkDerivation rec {
      inherit pname;
      version = "8.0-beta.2";
      src = fetchurl {
        url = "https://github.com/subframe7536/Maple-font/releases/download/v${version}/${pname}.zip";
        inherit hash;
      };

      # Work around the "unpacker appears to have produced no directories"
      # case that happens when the archive doesn't have a subdirectory.
      sourceRoot = ".";
      nativeBuildInputs = [ unzip ];
      installPhase = ''
        find . -name '*.ttf'    -exec install -Dt $out/share/fonts/truetype {} \;
        find . -name '*.otf'    -exec install -Dt $out/share/fonts/opentype {} \;
        find . -name '*.woff2'  -exec install -Dt $out/share/fonts/woff2 {} \;
      '';

      meta = {
        homepage = "https://github.com/subframe7536/Maple-font";
        description = ''
          Open source ${desc} font with round corner and ligatures for IDE and command line
        '';
        license = lib.licenses.ofl;
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [ oluceps ];
      };
    };

  # *Variants rules from `release-manifest.json`

  typeVariants = {
    truetype = {
      suffix = "TTF";
      desc = "TrueType";
    };

    truetype-autohint = {
      suffix = "TTF-AutoHint";
      desc = "TrueType AutoHint";
    };

    opentype = {
      suffix = "OTF";
      desc = "OpenType";
    };

    variable = {
      suffix = "VF";
      desc = "variable";
    };

    woff2 = {
      suffix = "Woff2";
      desc = "WOFF2.0";
    };

    NF = {
      suffix = "NF";
      desc = "Nerd Font";
    };

    NF-unhinted = {
      suffix = "NF-unhinted";
      desc = "Nerd Font unhinted";
    };

    NF-VF = {
      suffix = "NF-VF";
      desc = "Nerd Font variable";
    };

    NFMono-unhinted = {
      suffix = "NFMono-unhinted";
      desc = "Nerd Font Mono(icons occupy one Latin-character width) unhinted";
    };

    NFPropo-unhinted = {
      suffix = "NFPropo-unhinted";
      desc = "Nerd Font Propo(variable-width icons) unhinted";
    };
  };

  widthVariants = {
    default = {
      suffix = "";
      desc = "Default width";
    };
    SL = {
      suffix = "SL";
      desc = "Slim width";
    };
  };

  ligatureVariants = {
    Ligature = {
      suffix = "";
      desc = "Default Ligature";
    };
    No-Ligature = {
      suffix = "NL";
      desc = "No Ligature";
    };
    Normal-Ligature = {
      suffix = "Normal";
      desc = "Normal Ligature";
    };
    Normal-No-Ligature = {
      suffix = "NormalNL";
      desc = "Normal No Ligature";
    };
  };

  cjkVariants = {
    CN = {
      suffix = "CN";
      desc = "Simplified Chinese, with common Traditional Chinese and Japanese ranges";
    };
    TC = {
      suffix = "TC";
      desc = "Traditional Chinese";
    };
    JP = {
      suffix = "JP";
      desc = "Japanese";
    };
    KR = {
      suffix = "KR";
      desc = "Korean";
    };
  };

  cjkTypeVariants = {
    default = {
      suffix = "";
      desc = "";
    };
    unhinted = {
      suffix = "-unhinted";
      desc = "unhinted";
    };
    VF = {
      suffix = "-VF";
      desc = "variable";
    };
  };

  toVariantList = variants: lib.mapAttrsToList (_: v: { inherit (v) suffix desc; }) variants;

  baseSuffix = combo: with combo; "${lig.suffix}${width.suffix}-${type.suffix}";
  baseDesc = combo: with combo; "${lig.desc} ${width.desc} ${type.desc}";
  baseCombos = lib.cartesianProduct {
    lig = toVariantList ligatureVariants;
    width = toVariantList widthVariants;
    type = toVariantList typeVariants;
  };

  cjkSuffix = combo: with combo; "${lig.suffix}${width.suffix}-NF-${lang.suffix}${type.suffix}";
  cjkDesc = combo: with combo; "${lig.desc} ${width.desc} ${lang.desc} ${type.desc}";
  cjkCombos = lib.cartesianProduct {
    lig = toVariantList ligatureVariants;
    width = toVariantList widthVariants;
    lang = toVariantList cjkVariants;
    type = toVariantList cjkTypeVariants;
  };

  mkPkgs =
    combos: getSuffix: getDesc:
    builtins.listToAttrs (
      map (
        combo:
        let
          suffix = getSuffix combo;

          pname = "MapleMono${suffix}";
        in
        lib.nameValuePair "${lib.removePrefix "-" suffix}" (maple-font {
          inherit pname;
          desc = getDesc combo;
          hash = hashes.${pname};
        })
      ) combos
    );

  combinedFonts = (mkPkgs baseCombos baseSuffix baseDesc) // (mkPkgs cjkCombos cjkSuffix cjkDesc);

in
combinedFonts
