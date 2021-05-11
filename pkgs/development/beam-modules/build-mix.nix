{ stdenv, writeText, elixir, erlang, hex, lib }:

{ name
, version
, src
, buildInputs ? [ ]
, beamDeps ? [ ]
, propagatedBuildInputs ? [ ]
, postPatch ? ""
, compilePorts ? false
, meta ? { }
, enableDebugInfo ? false
, mixEnv ? "prod"
, ...
}@attrs:

with lib;
let
  shell = drv: stdenv.mkDerivation {
    name = "interactive-shell-${drv.name}";
    buildInputs = [ drv ];
  };

  pkg = self: stdenv.mkDerivation (attrs // {
    name = "${name}-${version}";
    inherit version;
    inherit src;

    MIX_ENV = mixEnv;
    MIX_DEBUG = if enableDebugInfo then 1 else 0;
    HEX_OFFLINE = 1;

    setupHook = attrs.setupHook or
      writeText "setupHook.sh" ''
      addToSearchPath ERL_LIBS "$1/lib/erlang/lib"
    '';

    buildInputs = buildInputs ++ [ elixir hex ];
    propagatedBuildInputs = propagatedBuildInputs ++ beamDeps;

    configurePhase = attrs.configurePhase or ''
      runHook preConfigure

      mkdir -p _build/$MIX_ENV/lib

      while read -d ':' lib
      do
        for dir in $(ls $lib)
        do
          dest=$(echo "$dir" | cut -d '-' -f1)
          [[ $MIX_DEBUG -eq 1 ]] && echo "Linking $lib/$dir to _build/$MIX_ENV/lib/$dest"
          ln -s $lib/$dir _build/$MIX_ENV/lib/$dest
        done
      done <<< "$ERL_LIBS:"

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
in
fix pkg
