{ stdenvNoCC, elixir, hex, rebar, rebar3, cacert, git }:

{ name, version, sha256, src, mixEnv ? "prod", debug ? false, meta ? { } }:

with stdenvNoCC.lib;

stdenvNoCC.mkDerivation ({
  name = "mix-deps-${name}-${version}";

  phases = [ "configurePhase" "downloadPhase" ];

  nativeBuildInputs = [ elixir hex cacert git ];

  inherit src;

  MIX_ENV = mixEnv;
  MIX_REBAR = "${rebar}/bin/rebar";
  MIX_REBAR3 = "${rebar3}/bin/rebar3";
  MIX_DEBUG = if debug then 1 else 0;

  configurePhase = ''
    mkdir -p $out/deps
    mkdir -p $out/.hex
    export HEX_HOME="$out/.hex";
    export MIX_HOME="$TEMPDIR/.mix";
    export MIX_DEPS_PATH="$out/deps";
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
