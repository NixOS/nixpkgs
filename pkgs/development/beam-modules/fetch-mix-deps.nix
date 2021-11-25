{ stdenvNoCC, lib, elixir, hex, rebar, rebar3, cacert, git }@inputs:

{ pname
, version
, sha256
, src
, mixEnv ? "prod"
, debug ? false
, meta ? { }
, patches ? []
, elixir ? inputs.elixir
, hex ? inputs.hex.override { inherit elixir; }
, ...
}@attrs:

stdenvNoCC.mkDerivation (attrs // {
  nativeBuildInputs = [ elixir hex cacert git ];

  MIX_ENV = mixEnv;
  MIX_DEBUG = if debug then 1 else 0;
  DEBUG = if debug then 1 else 0; # for rebar3
  # the api with `mix local.rebar rebar path` makes a copy of the binary
  MIX_REBAR = "${rebar}/bin/rebar";
  MIX_REBAR3 = "${rebar3}/bin/rebar3";
  # there is a persistent download failure with absinthe 1.6.3
  # those defaults reduce the failure rate
  HEX_HTTP_CONCURRENCY = 1;
  HEX_HTTP_TIMEOUT = 120;

  configurePhase = attrs.configurePhase or ''
    runHook preConfigure
    export HEX_HOME="$TEMPDIR/.hex";
    export MIX_HOME="$TEMPDIR/.mix";
    export MIX_DEPS_PATH="$TEMPDIR/deps";

    # Rebar
    export REBAR_GLOBAL_CONFIG_DIR="$TMPDIR/rebar3"
    export REBAR_CACHE_DIR="$TMPDIR/rebar3.cache"
    runHook postConfigure
  '';

  inherit patches;

  dontBuild = true;

  installPhase = attrs.installPhase or ''
    runHook preInstall
    mix deps.get --only ${mixEnv}
    find "$TEMPDIR/deps" -path '*/.git/*' -a ! -name HEAD -exec rm -rf {} +
    cp -r --no-preserve=mode,ownership,timestamps $TEMPDIR/deps $out
    runHook postInstall
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars;
  inherit meta;
})
