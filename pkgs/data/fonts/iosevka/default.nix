{ stdenv, lib, pkgs, fetchFromGitHub, nodejs, nodePackages, remarshal
, ttfautohint-nox, otfcc

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

stdenv.mkDerivation rec {
  pname = if set != null then "iosevka-${set}" else "iosevka";

  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "Iosevka";
    rev = "v${version}";
    sha256 = "0k7xij473g5g0lwhb6qpn70v3n2d025dww3nlb7jwbpnp03zliz0";
  };

  nativeBuildInputs = [
    nodejs
    nodePackages."iosevka-build-deps-../../data/fonts/iosevka"
    remarshal
    otfcc
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
    ln -s ${
      nodePackages."iosevka-build-deps-../../data/fonts/iosevka"
    }/lib/node_modules/iosevka-build-deps/node_modules .
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    npm run build --no-update-notifier -- ttf::$pname >/dev/null
    runHook postBuild
  '';

  installPhase = ''
    fontdir="$out/share/fonts/$pname"
    install -d "$fontdir"
    install "dist/$pname/ttf"/* "$fontdir"
  '';

  enableParallelBuilding = true;

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
    ];
  };
}
