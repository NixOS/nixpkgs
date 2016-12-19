{ stdenv, writeText, elixir, erlang, hexRegistrySnapshot, hex, lib }:

{ name
, version
, src
, setupHook ? null
, buildInputs ? []
, beamDeps ? []
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

  debugInfoFlag = lib.optionalString (enableDebugInfo || elixir.debugInfo) "--debug-info";

  shell = drv: stdenv.mkDerivation {
          name = "interactive-shell-${drv.name}";
          buildInputs = [ drv ];
    };

  bootstrapper = ./mix-bootstrap;

  pkg = self: stdenv.mkDerivation ( attrs // {
    name = "${name}-${version}";
    inherit version;

    dontStrip = true;

    inherit src;

    setupHook = if setupHook == null
    then writeText "setupHook.sh" ''
       addToSearchPath ERL_LIBS "$1/lib/erlang/lib"
    ''
    else setupHook;

    inherit buildInputs;
    propagatedBuildInputs = [ hexRegistrySnapshot hex elixir ] ++ beamDeps;

    configurePhase = if configurePhase == null
    then ''
      runHook preConfigure
      ${erlang}/bin/escript ${bootstrapper}
      runHook postConfigure
    ''
    else configurePhase ;


    buildPhase = if buildPhase == null
    then ''
        runHook preBuild

        export HEX_OFFLINE=1
        export HEX_HOME=`pwd`
        export MIX_ENV=prod

        MIX_ENV=prod mix compile ${debugInfoFlag} --no-deps-check

        runHook postBuild
    ''
    else buildPhase;

    installPhase = if installPhase == null
    then ''
        runHook preInstall

        MIXENV=prod

        if [ -d "_build/shared" ]; then
          MIXENV=shared
        fi

        mkdir -p "$out/lib/erlang/lib/${name}-${version}"
        for reldir in src ebin priv include; do
          fd="_build/$MIXENV/lib/${name}/$reldir"
          [ -d "$fd" ] || continue
          cp -Hrt "$out/lib/erlang/lib/${name}-${version}" "$fd"
          success=1
        done

        runHook postInstall
    ''
    else installPhase;

    passthru = {
      packageName = name;
      env = shell self;
      inherit beamDeps;
    };
});
in fix pkg
