{ stdenv, writeText, erlang, rebar3, openssl, libyaml,
  pc, buildEnv, lib }:

{ name, version
, src
, setupHook ? null
, buildInputs ? [], beamDeps ? [], buildPlugins ? []
, postPatch ? ""
, compilePorts ? false
, installPhase ? null
, buildPhase ? null
, configurePhase ? null
, meta ? {}
, enableDebugInfo ? false
, ... }@attrs:

with stdenv.lib;

let
  debugInfoFlag = lib.optionalString (enableDebugInfo || erlang.debugInfo) "debug-info";

  ownPlugins = buildPlugins ++ (if compilePorts then [pc] else []);

  shell = drv: stdenv.mkDerivation {
          name = "interactive-shell-${drv.name}";
          buildInputs = [ drv ];
    };

  pkg = self: stdenv.mkDerivation (attrs // {

    name = "${name}-${version}";
    inherit version;

    buildInputs = buildInputs ++ [ erlang rebar3 openssl libyaml ];
    propagatedBuildInputs = unique (beamDeps ++ ownPlugins);

    dontStrip = true;
    # The following are used by rebar3-nix-bootstrap
    inherit compilePorts;
    buildPlugins = ownPlugins;

    inherit src;

    setupHook = if setupHook == null
    then writeText "setupHook.sh" ''
       addToSearchPath ERL_LIBS "$1/lib/erlang/lib/"
    ''
    else setupHook;

    postPatch = ''
      rm -f rebar rebar3
    '' + postPatch;

    configurePhase = if configurePhase == null
    then ''
      runHook preConfigure
      ${erlang}/bin/escript ${rebar3.bootstrapper} ${debugInfoFlag}
      runHook postConfigure
    ''
    else configurePhase;

    buildPhase = if buildPhase == null
    then ''
      runHook preBuild
      HOME=. rebar3 compile
      ${if compilePorts then ''
        HOME=. rebar3 pc compile
      '' else ''''}
      runHook postBuild
    ''
    else installPhase;

    installPhase = if installPhase == null
    then ''
      runHook preInstall
      mkdir -p "$out/lib/erlang/lib/${name}-${version}"
      for reldir in src ebin priv include; do
        fd="_build/default/lib/${name}/$reldir"
        [ -d "$fd" ] || continue
        cp -Hrt "$out/lib/erlang/lib/${name}-${version}" "$fd"
        success=1
      done
      runHook postInstall
    ''
    else installPhase;

    meta = {
      inherit (erlang.meta) platforms;
    } // meta;

    passthru = {
      packageName = name;
      env = shell self;
      inherit beamDeps;
    };
  });
in
  fix pkg
