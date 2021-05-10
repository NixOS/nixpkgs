{ stdenv, writeText, elixir, erlang, hex, lib }:

{ name
, version
, src
, buildInputs ? []
, beamDeps ? []
, postPatch ? ""
, compilePorts ? false
, meta ? {}
, enableDebugInfo ? false
, mixEnv ? "prod"
, ... }@attrs:

with lib;

let

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

    MIX_ENV = mixEnv;
    MIX_DEBUG = if enableDebugInfo then 1 else 0;
    HEX_OFFLINE = 1;

    setupHook = attrs.setupHook or
      writeText "setupHook.sh" ''
        addToSearchPath ERL_LIBS "$1/lib/erlang/lib"
      '';

    inherit buildInputs;
    propagatedBuildInputs = [ hex elixir ] ++ beamDeps;

    configurePhase = attrs.configurePhase or ''
      runHook preConfigure
      ${erlang}/bin/escript ${bootstrapper}
      runHook postConfigure
    '';

    buildPhase = attrs.buildPhase or ''
      runHook preBuild
      export HEX_HOME="$TEMPDIR/hex"
      export MIX_HOME="$TEMPDIR/mix"
      mix compile --no-deps-check
      runHook postBuild
    '';

    installPhase = attrs.installPhase or ''
      runHook preInstall
      if [ -d "_build/shared" ]; then
        MIX_ENV=shared
      fi
      mkdir -p "$out/lib/erlang/lib/${name}-${version}"
      for reldir in src ebin priv include; do
        fd="_build/$MIX_ENV/lib/${name}/$reldir"
        [ -d "$fd" ] || continue
        cp -Hrt "$out/lib/erlang/lib/${name}-${version}" "$fd"
        success=1
      done
      runHook postInstall
    '';

    passthru = {
      packageName = name;
      env = shell self;
      inherit beamDeps;
    };
});
in fix pkg
