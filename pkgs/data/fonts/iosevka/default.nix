{
  stdenv, lib, pkgs,
  fetchFromGitHub, fetchurl,
  nodejs, ttfautohint-nox, otfcc,

  # Custom font set options.
  # See https://github.com/be5invis/Iosevka#build-your-own-style
  design ? [], upright ? [], italic ? [], oblique ? [],
  family ? null, weights ? [],
  # Custom font set name. Required if any custom settings above.
  set ? null,
  # Extra parameters. Can be used for ligature mapping.
  extraParameters ? null
}:

assert (design != []) -> set != null;
assert (upright != []) -> set != null;
assert (italic != []) -> set != null;
assert (oblique != []) -> set != null;
assert (family != null) -> set != null;
assert (weights != []) -> set != null;

let
  system = builtins.currentSystem;
  nodePackages = import ./node-packages.nix { inherit pkgs system nodejs; };
in

let pname = if set != null then "iosevka-${set}" else "iosevka"; in

let
  version = "2.3.0";
  name = "${pname}-${version}";
  src = fetchFromGitHub {
    owner = "be5invis";
    repo ="Iosevka";
    rev = "v${version}";
    sha256 = "1qnbxhx9wvij9zia226mc3sy8j7bfsw5v1cvxvsbbwjskwqdamvv";
  };
in

with lib;
let quote = str: "\"" + str + "\""; in
let toTomlList = list: "[" + (concatMapStringsSep ", " quote list) +"]"; in
let unlines = concatStringsSep "\n"; in

let
  param = name: options:
    if options != [] then "${name}=${toTomlList options}" else null;
  config = unlines (lib.filter (x: x != null) [
    "[buildPlans.${pname}]"
    (param "design" design)
    (param "upright" upright)
    (param "italic" italic)
    (param "oblique" oblique)
    (if family != null then "family=\"${family}\"" else null)
    (param "weights" weights)
  ]);
  installNodeModules = unlines (lib.mapAttrsToList
    (name: value: "mkdir -p node_modules/${name}\n cp -r ${value.outPath}/lib/node_modules/. node_modules")
    nodePackages);
in

stdenv.mkDerivation {
  inherit name pname version src;

  nativeBuildInputs = [ nodejs ttfautohint-nox otfcc ];

  passAsFile = [ "config" "extraParameters" ];
  config = config;
  extraParameters = extraParameters;

  configurePhase = ''
    mkdir -p node_modules/.bin
    ${installNodeModules}
    ${optionalString (set != null) ''mv "$configPath" private-build-plans.toml''}
    ${optionalString (extraParameters != null) ''cat "$extraParametersPath" >> parameters.toml''}
  '';

  buildPhase = ''
    npm run build -- ttf::${pname}
  '';

  installPhase = ''
    fontdir="$out/share/fonts/$pname"
    install -d "$fontdir"
    install "dist/$pname/ttf"/* "$fontdir"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://be5invis.github.io/Iosevka/;
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = ''
      Slender monospace sans-serif and slab-serif typeface inspired by Pragmata
      Pro, M+ and PF DIN Mono, designed to be the ideal font for programming.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ cstrahan jfrankenau ttuegel babariviere ];
  };
}
