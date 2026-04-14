{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

let
  version = "v2.0.0-beta.1";

  mkFont =
    {
      width,
      hash,
      isNF ? false,
      variant ? "Hinted",
    }:
    let
      variantName = lib.toLower width;
      pkgSuffix = if isNF then "${variantName}-NF" else variantName;
      fileName = "IoskeleyMono-${if isNF then "NerdFont-" else ""}${width}.zip";
    in
    stdenvNoCC.mkDerivation {
      pname = "ioskeley-mono-${pkgSuffix}";
      inherit version;

      src = fetchzip {
        url = "https://github.com/ahatem/IoskeleyMono/releases/download/${version}/${fileName}";
        stripRoot = false;
        inherit hash;
      };
      sourceRoot = if isNF then "." else "source/${variant}";

      nativeBuildInputs = [ installFonts ];

      fontDirectories = [
        "."
        "Hinted"
      ];

      meta = {
        homepage = "https://github.com/ahatem/IoskeleyMono";
        description = "Iosevka configuration mimicking Berkeley Mono (${width}${
          if isNF then ", Nerd Font" else ""
        })";
        license = lib.licenses.ofl;
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [ nuexq ];
      };
    };
in
{
  normal = mkFont {
    width = "Normal";
    hash = "sha256-ZuV4yg6H0SayGo3LB2Naqn4axR0Lnmw95u/jiRk5B/U=";
  };
  normal-unhinted = mkFont {
    width = "Normal";
    hash = "sha256-ZuV4yg6H0SayGo3LB2Naqn4axR0Lnmw95u/jiRk5B/U=";
    variant = "Unhinted";
  };
  semiCondensed = mkFont {
    width = "SemiCondensed";
    hash = "sha256-fOuQmf+ANuKy3kaLRbAu9RIsL3rORGJUlR/BerDg60U=";
  };
  semiCondensed-unhinted = mkFont {
    width = "SemiCondensed";
    hash = "sha256-fOuQmf+ANuKy3kaLRbAu9RIsL3rORGJUlR/BerDg60U=";
    variant = "Unhinted";
  };
  condensed = mkFont {
    width = "Condensed";
    hash = "sha256-bzEh9YvbERZrIvXZPopHwhkSe87y3MdHhLaRGWLvTQU=";
  };
  condensed-unhinted = mkFont {
    width = "Condensed";
    hash = "sha256-bzEh9YvbERZrIvXZPopHwhkSe87y3MdHhLaRGWLvTQU=";
    variant = "Unhinted";
  };
  normal-NF = mkFont {
    width = "Normal";
    hash = "sha256-rhSU4Md6D7hLT6EeH3TMetPgQGuiYowpYVaZqewGgh8=";
    isNF = true;
  };
  semiCondensed-NF = mkFont {
    width = "SemiCondensed";
    hash = "sha256-W1ykPzdsoXfRBJ5YuxrjOc/J7uzwLQRjZTc9G2cj06Y=";
    isNF = true;
  };
  condensed-NF = mkFont {
    width = "Condensed";
    hash = "sha256-TAneNRImlRNsvTr6xDCG+VKFycttbTxkP6hfh9Kr+X4=";
    isNF = true;
  };
}
