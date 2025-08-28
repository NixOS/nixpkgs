{
  lib,
  stdenv,
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
    stdenv.mkDerivation rec {
      inherit pname;
      version = "7.6";
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

      meta = with lib; {
        homepage = "https://github.com/subframe7536/Maple-font";
        description = ''
          Open source ${desc} font with round corner and ligatures for IDE and command line
        '';
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [ oluceps ];
      };
    };

  typeVariants = {
    truetype = {
      suffix = "TTF";
      desc = "monospace TrueType";
    };

    truetype-autohint = {
      suffix = "TTF-AutoHint";
      desc = "monospace ttf autohint";
    };

    variable = {
      suffix = "Variable";
      desc = "monospace variable";
    };

    woff2 = {
      suffix = "Woff2";
      desc = "WOFF2.0";
    };

    opentype = {
      suffix = "OTF";
      desc = "OpenType";
    };

    NF = {
      suffix = "NF";
      desc = "Nerd Font";
    };

    NF-unhinted = {
      suffix = "NF-unhinted";
      desc = "Nerd Font unhinted";
    };

    CN = {
      suffix = "CN";
      desc = "monospace CN";
    };

    CN-unhinted = {
      suffix = "CN-unhinted";
      desc = "monospace CN unhinted";
    };

    NF-CN = {
      suffix = "NF-CN";
      desc = "Nerd Font CN";
    };

    NF-CN-unhinted = {
      suffix = "NF-CN-unhinted";
      desc = "Nerd Font CN unhinted";
    };
  };

  ligatureVariants = {
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

  combinedFonts =
    lib.concatMapAttrs (
      ligName: ligVariant:
      lib.concatMapAttrs (
        typeName: typeVariant:
        let
          pname = "MapleMono${ligVariant.suffix}-${typeVariant.suffix}";
        in
        {
          "${ligVariant.suffix}-${typeVariant.suffix}" = maple-font {
            inherit pname;
            desc = "${ligVariant.desc} ${typeVariant.desc}";
            hash = hashes.${pname};
          };
        }
      ) typeVariants
    ) ligatureVariants
    // lib.mapAttrs (
      _: value:
      let
        pname = "MapleMono-${value.suffix}";
      in
      maple-font {
        inherit pname;
        inherit (value) desc;
        hash = hashes.${pname};
      }
    ) typeVariants;
in
combinedFonts
