{ stdenv, lib, pkgs, fetchFromGitHub, nodejs, nodePackages, remarshal
, ttfautohint-nox
  # Custom font set options.
  # See https://typeof.net/Iosevka/customizer
  # Can be a raw TOML string, or a Nix attrset.

  # Ex:
  # privateBuildPlan = ''
  #   [buildPlans.iosevka-custom]
  #   family = "Iosevka Custom"
  #   spacing = "normal"
  #   serifs = "sans"
  #
  #   [buildPlans.iosevka-custom.variants.design]
  #   capital-j = "serifless"
  #
  #   [buildPlans.iosevka-custom.variants.italic]
  #   i = "tailed"
  # '';

  # Or:
  # privateBuildPlan = {
  #   family = "Iosevka Custom";
  #   spacing = "normal";
  #   serifs = "sans";
  #
  #   variants = {
  #     design.capital-j = "serifless";
  #     italic.i = "tailed";
  #   };
  # }
, privateBuildPlan ? null
  # Extra parameters. Can be used for ligature mapping.
  # It must be a raw TOML string.

  # Ex:
  # extraParameters = ''
  #   [[iosevka.compLig]]
  #   unicode = 57808 # 0xe1d0
  #   featureTag = 'XHS0'
  #   sequence = "+>"
  # '';
, extraParameters ? null
  # Custom font set name. Required if any custom settings above.
, set ? null }:

assert (privateBuildPlan != null) -> set != null;
assert (extraParameters != null) -> set != null;

let
  # We don't know the attribute name for the Iosevka package as it
  # changes not when our update script is run (which in turn updates
  # node-packages.json, but when node-packages/generate.sh is run
  # (which updates node-packages.nix).
  #
  # Doing it this way ensures that the package can always be built,
  # although possibly an older version than ioseva-bin.
  nodeIosevka = (
    lib.findSingle
      (drv: drv ? packageName && drv.packageName == "iosevka")
      (throw "no 'iosevka' package found in nodePackages")
      (throw "multiple 'iosevka' packages found in nodePackages")
      (lib.attrValues nodePackages)
  ).override (drv: { dontNpmInstall = true; });
in
stdenv.mkDerivation rec {
  pname = if set != null then "iosevka-${set}" else "iosevka";
  inherit (nodeIosevka) version src;

  nativeBuildInputs = [
    nodejs
    nodeIosevka
    remarshal
    ttfautohint-nox
  ];

  buildPlan =
    if builtins.isAttrs privateBuildPlan
      then builtins.toJSON { buildPlans.${pname} = privateBuildPlan; }
    else privateBuildPlan;

  inherit extraParameters;
  passAsFile = [ "buildPlan" "extraParameters" ];

  configurePhase = ''
    runHook preConfigure
    ${lib.optionalString (builtins.isAttrs privateBuildPlan) ''
      remarshal -i "$buildPlanPath" -o private-build-plans.toml -if json -of toml
    ''}
    ${lib.optionalString (builtins.isString privateBuildPlan) ''
      cp "$buildPlanPath" private-build-plans.toml
    ''}
    ${lib.optionalString (extraParameters != null) ''
      echo -e "\n" >> params/parameters.toml
      cat "$extraParametersPath" >> params/parameters.toml
    ''}
    ln -s ${nodeIosevka}/lib/node_modules/iosevka/node_modules .
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    npm run build --no-update-notifier -- --jCmd=$NIX_BUILD_CORES ttf::$pname >/dev/null
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    fontdir="$out/share/fonts/truetype"
    install -d "$fontdir"
    install "dist/$pname/ttf"/* "$fontdir"
    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru = {
    updateScript = ./update-default.sh;
  };

  meta = with lib; {
    homepage = "https://be5invis.github.io/Iosevka";
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = ''
      Slender monospace sans-serif and slab-serif typeface inspired by Pragmata
      Pro, M+ and PF DIN Mono, designed to be the ideal font for programming.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [
      cstrahan
      jfrankenau
      ttuegel
      babariviere
      rileyinman
      AluisioASG
    ];
  };
}
