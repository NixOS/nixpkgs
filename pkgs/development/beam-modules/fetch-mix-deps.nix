{ stdenvNoCC, lib, elixir, hex, rebar, rebar3, cacert, git }:

{ name, version, sha256, src, mixEnv ? "prod", debug ? false, meta ? { } }:

stdenvNoCC.mkDerivation ({
  name = "mix-deps-${name}-${version}";

  nativeBuildInputs = [ elixir hex cacert git ];

  inherit src;

  MIX_ENV = mixEnv;
  MIX_DEBUG = if debug then 1 else 0;
  DEBUG = if debug then 1 else 0; # for rebar3

  configurePhase = ''
    export HEX_HOME="$TEMPDIR/.hex";
    export MIX_HOME="$TEMPDIR/.mix";
    export MIX_DEPS_PATH="$out";

    # Rebar
    mix local.rebar rebar "${rebar}/bin/rebar"
    mix local.rebar rebar3 "${rebar3}/bin/rebar3"
    export REBAR_GLOBAL_CONFIG_DIR="$TMPDIR/rebar3"
    export REBAR_CACHE_DIR="$TMPDIR/rebar3.cache"
  '';

  dontBuild = true;

  installPhase = ''
    mix deps.get --only ${mixEnv}
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars;
  inherit meta;
})
