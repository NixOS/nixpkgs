{ stdenv, lib, pkgs, fetchFromGitHub, nodejs, nodePackages, remarshal
, ttfautohint-nox

# Custom font set options.
# See https://github.com/be5invis/Iosevka#build-your-own-style
# Ex:
# privateBuildPlan = {
#   family = "Iosevka Expanded";
#
#   design = [
#     "sans"
#     "expanded"
#   ];
# };
, privateBuildPlan ? null
  # Extra parameters. Can be used for ligature mapping.
  # It must be a raw toml string.
  #
  # Ex:
  # [[iosevka.compLig]]
  # unicode = 57808 # 0xe1d0
  # featureTag = 'XHS0'
  # sequence = "+>"
, extraParameters ? null
  # Custom font set name. Required if any custom settings above.
, set ? null }:

assert (privateBuildPlan != null) -> set != null;

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

  privateBuildPlanJSON =
    builtins.toJSON { buildPlans.${pname} = privateBuildPlan; };
  inherit extraParameters;
  passAsFile = [ "privateBuildPlanJSON" "extraParameters" ];

  configurePhase = ''
    runHook preConfigure
    ${lib.optionalString (privateBuildPlan != null) ''
      remarshal -i "$privateBuildPlanJSONPath" -o private-build-plans.toml -if json -of toml
    ''}
    ${lib.optionalString (extraParameters != null) ''
      echo -e "\n" >> parameters.toml
      cat "$extraParametersPath" >> parameters.toml
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

  meta = with stdenv.lib; {
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
