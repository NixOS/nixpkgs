{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,

  width ? "Normal",
  hinted ? true,
}:

let
  version = "v2.1.0";

  mkFont =
    {
      variant ? "",
      hash,
      isNF ? false,
    }:
    let
      fileName = "IoskeleyMono${if variant != "" then "-${variant}" else ""}${
        if isNF then "-NerdFont" else ""
      }.zip";
      hintDir = if hinted then "Hinted" else "Unhinted";

      pname =
        let
          vPart = if variant != "" then "-${variant}" else "";
          nfPart = if isNF then "-NF" else "";
        in
        "ioskeley-mono${vPart}${nfPart}";
    in
    stdenvNoCC.mkDerivation {
      inherit pname version;

      src = fetchzip {
        url = "https://github.com/ahatem/IoskeleyMono/releases/download/${version}/${fileName}";
        stripRoot = false;
        inherit hash;
      };

      sourceRoot = if isNF then "source/${width}" else "source/${width}/${hintDir}";

      nativeBuildInputs = [ installFonts ];

      meta = {
        homepage = "https://github.com/ahatem/IoskeleyMono";
        description = "Iosevka configuration mimicking Berkeley Mono, ${width} width${
          if variant != "" then ", ${variant} variant" else ""
        }${if isNF then ", Nerd Font patched" else ""}${if !hinted then ", unhinted" else ""}";
        license = lib.licenses.ofl;
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [ nuexq ];
      };
    };
in
{
  # Standard
  standard = mkFont {
    hash = "sha256-1WGAPwbfSG3fpssUTnHCTVI8eKNHSHWHdfdq4JUQ9ls=";
  };

  # Term
  term = mkFont {
    variant = "Term";
    hash = "sha256-Ei6cRAMC9C62X8coHsTMvfPZfloiUp+A4HeT89df3pk=";
  };

  # Term Nerd Font
  term-nf = mkFont {
    variant = "Term";
    isNF = true;
    hash = "sha256-joAhNADErBErDqTrNelJ0ulGZCN/OUZ1SMYyU++7l6U=";
  };

  # NL
  nl = mkFont {
    variant = "NL";
    hash = "sha256-3zqO7W23Zcdz7L8cO0A8oAH0PQqYUNwKiKnAmN/Ja8s=";
  };

  # NL Nerd Font
  nl-nf = mkFont {
    variant = "NL";
    isNF = true;
    hash = "sha256-3eTVqMlLx/AF3aoTbQ68Qzhr5nQzWIKt4HWZZsH2yE0=";
  };

  # Nerd Font Standard
  nf = mkFont {
    isNF = true;
    hash = "sha256-b0mqhLeDT+uYPYiOKB+cxc5M1TtFkICKAmlcmW3IjDg=";
  };
}
