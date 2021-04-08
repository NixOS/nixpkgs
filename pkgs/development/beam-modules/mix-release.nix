{ stdenv, lib, elixir, erlang, findutils, hex, rebar, rebar3, fetchMixDeps, makeWrapper, git }:

{ pname
, version
, src
, nativeBuildInputs ? [ ]
, meta ? { }
, enableDebugInfo ? false
, mixEnv ? "prod"
, compileFlags ? [ ]
, mixDeps ? null
, ...
}@attrs:
let
  overridable = builtins.removeAttrs attrs [ "compileFlags" ];

in
stdenv.mkDerivation (overridable // {
  nativeBuildInputs = nativeBuildInputs ++ [ erlang hex elixir makeWrapper git ];

  MIX_ENV = mixEnv;
  MIX_DEBUG = if enableDebugInfo then 1 else 0;
  HEX_OFFLINE = 1;
  DEBUG = if enableDebugInfo then 1 else 0; # for Rebar3 compilation
  # the api with `mix local.rebar rebar path` makes a copy of the binary
  MIX_REBAR = "${rebar}/bin/rebar";
  MIX_REBAR3 = "${rebar3}/bin/rebar3";

  postUnpack = ''
    export HEX_HOME="$TEMPDIR/hex"
    export MIX_HOME="$TEMPDIR/mix"
    # compilation of the dependencies will require
    # that the dependency path is writable
    # thus a copy to the TEMPDIR is inevitable here
    export MIX_DEPS_PATH="$TEMPDIR/deps"

    # Rebar
    export REBAR_GLOBAL_CONFIG_DIR="$TEMPDIR/rebar3"
    export REBAR_CACHE_DIR="$TEMPDIR/rebar3.cache"

    ${lib.optionalString (mixDeps != null) ''
      cp --no-preserve=mode -R "${mixDeps}" "$MIX_DEPS_PATH"
    ''
    }

  '' + (attrs.postUnpack or "");

  configurePhase = attrs.configurePhase or ''
    runHook preConfigure

    # this is needed for projects that have a specific compile step
    # the dependency needs to be compiled in order for the task
    # to be available
    # Phoenix projects for example will need compile.phoenix
    mix deps.compile --no-deps-check --skip-umbrella-children

    runHook postConfigure
  '';

  buildPhase = attrs.buildPhase or ''
    runHook preBuild

    mix compile --no-deps-check ${lib.concatStringsSep " " compileFlags}

    runHook postBuild
  '';


  installPhase = attrs.installPhase or ''
    runHook preInstall

    mix release --no-deps-check --path "$out"

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup
    if [ -e "$out/bin/${pname}.bat" ]; then # absent in special cases, i.e. elixir-ls
      rm "$out/bin/${pname}.bat" # windows file
    fi
    # contains secrets and should not be in the nix store
    # TODO document how to handle RELEASE_COOKIE
    # secrets should not be in the nix store.
    # This is only used for connecting multiple nodes
    if [ -e $out/releases/COOKIE ]; then # absent in special cases, i.e. elixir-ls
      rm $out/releases/COOKIE
    fi
    # TODO remove the uneeded reference too erlang
    # one possible way would be
    # for f in $(${findutils}/bin/find $out -name start); do
    #   substituteInPlace $f \
    #     --replace 'ROOTDIR=${erlang}/lib/erlang' 'ROOTDIR=""'
    # done
    # What is left to do is to check that erlang is not required on
    # the host

    patchShebangs $out
    runHook postFixup
  '';
  # TODO figure out how to do a Fixed Output Derivation and add the output hash
  # This doesn't play well at the moment with Phoenix projects
  # for example that have frontend dependencies

  # disallowedReferences = [ erlang ];
})
