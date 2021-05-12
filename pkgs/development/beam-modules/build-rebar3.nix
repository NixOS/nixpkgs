{ stdenv, writeText, erlang, rebar3WithPlugins, openssl, libyaml, lib }:

{ name, version
, src
, setupHook ? null
, buildInputs ? [], beamDeps ? [], buildPlugins ? []
, postPatch ? ""
, installPhase ? null
, buildPhase ? null
, configurePhase ? null
, meta ? {}
, enableDebugInfo ? false
, ... }@attrs:

with lib;

let
  debugInfoFlag = lib.optionalString (enableDebugInfo || erlang.debugInfo) "debug-info";

  rebar3 = rebar3WithPlugins {
    plugins = buildPlugins;
  };

  shell = drv: stdenv.mkDerivation {
          name = "interactive-shell-${drv.name}";
          buildInputs = [ drv ];
    };

  customPhases = filterAttrs
    (_: v: v != null)
    { inherit setupHook configurePhase buildPhase installPhase; };

  pkg = self: stdenv.mkDerivation (attrs // {

    name = "${name}-${version}";
    inherit version;

    buildInputs = buildInputs ++ [ erlang rebar3 openssl libyaml ];
    propagatedBuildInputs = unique beamDeps;

    dontStrip = true;
    inherit src;

    setupHook = writeText "setupHook.sh" ''
       addToSearchPath ERL_LIBS "$1/lib/erlang/lib/"
    '';

    postPatch = ''
      rm -f rebar rebar3
    '' + postPatch;

    buildPhase = ''
      runHook preBuild
      HOME=. rebar3 bare compile -path ""
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/lib/erlang/lib/${name}-${version}"
      for reldir in src ebin priv include; do
        [ -d "$reldir" ] || continue
        # $out/lib/erlang/lib is a convention used in nixpkgs for compiled BEAM packages
        cp -Hrt "$out/lib/erlang/lib/${name}-${version}" "$reldir"
      done
      runHook postInstall
    '';

    meta = {
      inherit (erlang.meta) platforms;
    } // meta;

    passthru = {
      packageName = name;
      env = shell self;
      inherit beamDeps;
    };
  } // customPhases);
in
  fix pkg
