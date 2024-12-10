{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  cctools,
  remarshal,
  ttfautohint-nox,
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
  privateBuildPlan ? null,
  # Extra parameters. Can be used for ligature mapping.
  # It must be a raw TOML string.

  # Ex:
  # extraParameters = ''
  #   [[iosevka.compLig]]
  #   unicode = 57808 # 0xe1d0
  #   featureTag = 'XHS0'
  #   sequence = "+>"
  # '';
  extraParameters ? null,
  # Custom font set name. Required if any custom settings above.
  set ? null,
}:

assert (privateBuildPlan != null) -> set != null;
assert (extraParameters != null) -> set != null;

buildNpmPackage rec {
  pname = "Iosevka${toString set}";
  version = "31.8.0";

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    rev = "v${version}";
    hash = "sha256-GGtbW4Y/02ubdufTXmywGS4jyMfm8RfOMvmUNoUcLQg=";
  };

  npmDepsHash = "sha256-/zLWtIIPNOMrICKaj5SY1Bo3Pdso6a776fIYY/7X0U4=";

  nativeBuildInputs =
    [
      remarshal
      ttfautohint-nox
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # libtool
      cctools
    ];

  buildPlan =
    if builtins.isAttrs privateBuildPlan then
      builtins.toJSON { buildPlans.${pname} = privateBuildPlan; }
    else
      privateBuildPlan;

  inherit extraParameters;
  passAsFile =
    [ "extraParameters" ]
    ++ lib.optionals (
      !(builtins.isString privateBuildPlan && lib.hasPrefix builtins.storeDir privateBuildPlan)
    ) [ "buildPlan" ];

  configurePhase = ''
    runHook preConfigure
    ${lib.optionalString (builtins.isAttrs privateBuildPlan) ''
      remarshal -i "$buildPlanPath" -o private-build-plans.toml -if json -of toml
    ''}
    ${lib.optionalString
      (builtins.isString privateBuildPlan && (!lib.hasPrefix builtins.storeDir privateBuildPlan))
      ''
        cp "$buildPlanPath" private-build-plans.toml
      ''
    }
    ${lib.optionalString
      (builtins.isString privateBuildPlan && (lib.hasPrefix builtins.storeDir privateBuildPlan))
      ''
        cp "$buildPlan" private-build-plans.toml
      ''
    }
    ${lib.optionalString (extraParameters != null) ''
      echo -e "\n" >> params/parameters.toml
      cat "$extraParametersPath" >> params/parameters.toml
    ''}
    runHook postConfigure
  '';

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild
    npm run build --no-update-notifier --targets ttf::$pname -- --jCmd=$NIX_BUILD_CORES --verbose=9
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    fontdir="$out/share/fonts/truetype"
    install -d "$fontdir"
    install "dist/$pname/TTF"/* "$fontdir"
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://typeof.net/Iosevka/";
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = "Versatile typeface for code, from code";
    longDescription = ''
      Iosevka is an open-source, sans-serif + slab-serif, monospace +
      quasi‑proportional typeface family, designed for writing code, using in
      terminals, and preparing technical documents.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [
      ttuegel
      rileyinman
      lunik1
    ];
  };
}
