{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  mkVariant =
    variant: hash:
    stdenvNoCC.mkDerivation {
      pname = "tex-gyre-${variant}";
      version = "2.609";

      src = fetchzip {
        url = "https://www.gust.org.pl/projects/e-foundry/tex-gyre/${variant}/tg_${variant}-otf-2_609-31_03_2026.zip";
        stripRoot = false;
        inherit hash;
      };

      installPhase = ''
        runHook preInstall

        install -Dm644 -t $out/share/fonts/opentype *.otf

        runHook postInstall
      '';

      meta = {
        description = "TeX Gyre ${variant} font family";
        homepage = "https://www.gust.org.pl/projects/e-foundry/tex-gyre";
        # "The TeX Gyre fonts are licensed under the GUST Font License (GFL),
        # which is a free license, legally equivalent to the LaTeX Project Public
        # License (LPPL), version 1.3c or later." - GUST website
        license = lib.licenses.lppl13c;
        maintainers = [ ];
        platforms = lib.platforms.all;
      };
    };
in
lib.mapAttrs mkVariant {
  adventor = "sha256-NNxrd+7czGyWfiPOnG+6OLykmxUmfE5kTvGU9/TUdBY=";
  bonum = "sha256-J9BOJislEgruCfQmzzV+92dmTFpTiIS6UBr53+yTUf4=";
  chorus = "sha256-JCH3+RczjTndZD3dPLDPb4Y4ksbGXz0Dcsixrv8rR30=";
  cursor = "sha256-QCqVa6qn8EFCjM7Tgcmp5REQD+PuW6LVMqGh64DahtU=";
  heros = "sha256-vV2C4jYldzX8qQ+9jxvSNn4teZgU6K4vcDzxwrBGGR8=";
  pagella = "sha256-p3LuwAZAvLeU48qddzXmU9n48hqR17ssX54MWnK5938=";
  schola = "sha256-WNgVrFdgx5eA0K1Ej92CqeCAwUgVSfr+530I6XPib8Q=";
  termes = "sha256-CrEeqsiMKUN8Aw+Ub8+EWnAhcVp9uL0skqLySxyzGYU=";
}
