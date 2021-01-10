{ stdenvNoCC, elixir, hex, rebar, rebar3, cacert, git }:

{ name, version, sha256, src, mixEnv ? "prod", debug ? false, meta ? { } }:

with stdenvNoCC.lib;

stdenvNoCC.mkDerivation ({
  name = "mix-deps-${name}-${version}";

  phases = [ "configurePhase" "downloadPhase" ];

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

  downloadPhase = ''
    ln -s ${src}/mix.exs ./mix.exs
    ln -s ${src}/mix.lock ./mix.lock
    mix deps.get --only ${mixEnv}
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = stdenvNoCC.lib.fetchers.proxyImpureEnvVars;
  inherit meta;
})
