{
  stdenv, lib,
  fetchFromGitHub, fetchurl,
  nodejs, ttfautohint-nox, otfcc,

  # Custom font set options.
  # See https://github.com/be5invis/Iosevka#build-your-own-style
  design ? [], upright ? [], italic ? [], oblique ? [],
  family ? null, weights ? [],
  # Custom font set name. Required if any custom settings above.
  set ? null
}:

assert (design != []) -> set != null;
assert (upright != []) -> set != null;
assert (italic != []) -> set != null;
assert (oblique != []) -> set != null;
assert (family != null) -> set != null;
assert (weights != []) -> set != null;

let
  installPackageLock = import ./package-lock.nix { inherit fetchurl lib; };
in

let pname = if set != null then "iosevka-${set}" else "iosevka"; in

let
  version = "1.14.3";
  name = "${pname}-${version}";
  src = fetchFromGitHub {
    owner = "be5invis";
    repo ="Iosevka";
    rev = "v${version}";
    sha256 = "0ba8hwxi88bp2jb9xfhk95nnlv8ykl74cv62xr4ybzm3b8ahpwqf";
  };
in

with lib;
let unwords = concatStringsSep " "; in

let
  param = name: options:
    if options != [] then "${name}='${unwords options}'" else null;
  config = unwords (lib.filter (x: x != null) [
    (param "design" design)
    (param "upright" upright)
    (param "italic" italic)
    (param "oblique" oblique)
    (if family != null then "family='${family}'" else null)
    (param "weights" weights)
  ]);
  custom = design != [] || upright != [] || italic != [] || oblique != []
    || family != null || weights != [];
in

stdenv.mkDerivation {
  inherit name pname version src;

  nativeBuildInputs = [ nodejs ttfautohint-nox otfcc ];

  passAsFile = [ "installPackageLock" ];
  installPackageLock = installPackageLock ./package-lock.json;

  preConfigure = ''
    HOME=$TMPDIR
    source "$installPackageLockPath";
    npm --offline rebuild
  '';

  configurePhase = ''
    runHook preConfigure

    ${optionalString custom ''make custom-config set=${set} ${config}''}

    runHook postConfigure
  '';

  makeFlags = lib.optionals custom [ "custom" "set=${set}" ];

  installPhase = ''
    runHook preInstall

    fontdir="$out/share/fonts/$pname"
    install -d "$fontdir"
    install "dist/$pname/ttf"/* "$fontdir"

    runHook postInstall
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
    maintainers = with maintainers; [ cstrahan jfrankenau ttuegel ];
  };
}
