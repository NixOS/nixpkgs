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

    # stripping does not have any effect on beam files
    dontStrip = true;

    # add to ERL_LIBS so other modules can find at runtime.
    # http://erlang.org/doc/man/code.html#code-path
    setupHook = attrs.setupHook or
      writeText "setupHook.sh" ''
      addToSearchPath ERL_LIBS "$1/lib/erlang/lib"
    '';

    buildInputs = buildInputs ++ [ elixir hex ];
    propagatedBuildInputs = propagatedBuildInputs ++ beamDeps;

    buildPhase = attrs.buildPhase or ''
      runHook preBuild
      export HEX_HOME="$TEMPDIR/hex"
      export MIX_HOME="$TEMPDIR/mix"
      mix compile --no-deps-check
      runHook postBuild
    '';

    installPhase = attrs.installPhase or ''
      runHook preInstall

      # Some packages will use _build/shared instead of honoring the $MIX_ENV
      # variable.
      if [ -d "_build/shared" ]; then
        MIX_ENV=shared
      fi

      # This uses the install path convention established by nixpkgs maintainers
      # for all beam packages. There is no magic here.
      mkdir -p "$out/lib/erlang/lib/${name}-${version}"
      for reldir in src ebin priv include; do
        fd="_build/$MIX_ENV/lib/${name}/$reldir"
        [ -d "$fd" ] || continue
        cp -Hrt "$out/lib/erlang/lib/${name}-${version}" "$fd"
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
