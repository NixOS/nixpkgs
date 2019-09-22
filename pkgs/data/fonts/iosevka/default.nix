{ stdenv, lib, pkgs
, nodejs, remarshal, ttfautohint-nox, otfcc

# Custom font set options.
# See https://github.com/be5invis/Iosevka#build-your-own-style
, privateBuildPlan ? null
# Extra parameters. Can be used for ligature mapping.
, extraParameters ? null
# Custom font set name. Required if any custom settings above.
, set ? null
}:

assert (privateBuildPlan != null) -> set != null;

let
  nodePackages = import ./node-packages.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
stdenv.mkDerivation rec {
  pname =
    if set != null
    then "iosevka-${set}"
    else "iosevka";

  inherit (src) version;

  src = nodePackages."iosevka-https://github.com/be5invis/Iosevka/archive/v2.3.0.tar.gz";
  sourceRoot = "${src.name}/lib/node_modules/iosevka";

  nativeBuildInputs = [
    nodejs
    remarshal
    otfcc
    ttfautohint-nox
  ];

  privateBuildPlanJSON = builtins.toJSON { buildPlans.${pname} = privateBuildPlan; };
  extraParametersJSON = builtins.toJSON { ${pname} = extraParameters; };
  passAsFile = [ "privateBuildPlanJSON" "extraParametersJSON" ];

  configurePhase = ''
    runHook preConfigure
    ${lib.optionalString (privateBuildPlan != null) ''
      remarshal -i "$privateBuildPlanJSONPath" -o private-build-plans.toml -if json -of toml
    ''}
    ${lib.optionalString (extraParameters != null) ''
      echo -e "\n" >> parameters.toml
      remarshal -i "$extraParametersJSONPath" -if json -of toml >> parameters.toml
    ''}
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    npm run build -- ttf::$pname
    runHook postBuild
  '';

  installPhase = ''
    fontdir="$out/share/fonts/$pname"
    install -d "$fontdir"
    install "dist/$pname/ttf"/* "$fontdir"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://be5invis.github.io/Iosevka;
    downloadPage = https://github.com/be5invis/Iosevka/releases;
    description = ''
      Slender monospace sans-serif and slab-serif typeface inspired by Pragmata
      Pro, M+ and PF DIN Mono, designed to be the ideal font for programming.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ cstrahan jfrankenau ttuegel babariviere ];
  };
}
