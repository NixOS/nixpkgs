{ stdenv, erlang, rebar3WithPlugins, openssl,
  lib }:

{ name, version
, src
, beamDeps ? []
, buildPlugins ? []
, checkouts ? null
, releaseType
, buildInputs ? []
, setupHook ? null
, profile ? "default"
, installPhase ? null
, buildPhase ? null
, configurePhase ? null
, meta ? {}
, ... }@attrs:

with lib;

let
  shell = drv: stdenv.mkDerivation {
          name = "interactive-shell-${drv.name}";
          buildInputs = [ drv ];
    };

  customPhases = filterAttrs
    (_: v: v != null)
    { inherit setupHook configurePhase buildPhase installPhase; };

  # When using the `beamDeps` argument, it is important that we use
  # `rebar3WithPlugins` here even when there are no plugins. The vanilla
  # `rebar3` package is an escript archive with bundled dependencies which can
  # interfere with those in the app we are trying to build. `rebar3WithPlugins`
  # doesn't have this issue since it puts its own deps last on the code path.
  rebar3 = rebar3WithPlugins {
    plugins = buildPlugins;
  };

  pkg =
    assert beamDeps != [] -> checkouts == null;
    self: stdenv.mkDerivation (attrs // {

    name = "${name}-${version}";
    inherit version;

    buildInputs = buildInputs ++ [ erlang rebar3 openssl ] ++ beamDeps;

    dontStrip = true;

    inherit src;

    configurePhase = ''
      runHook preConfigure
      ${lib.optionalString (checkouts != null)
      "cp --no-preserve=all -R ${checkouts}/_checkouts ."}
      ${# Prevent rebar3 from trying to manage deps
      lib.optionalString (beamDeps != [ ]) ''
        erl -noshell -eval '
          {ok, Terms0} = file:consult("rebar.config"),
          Terms = lists:keydelete(deps, 1, Terms0),
          ok = file:write_file("rebar.config", [io_lib:format("~tp.~n", [T]) || T <- Terms]),
          init:stop(0)
        '
        rm -f rebar.lock
      ''}
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      HOME=. DEBUG=1 rebar3 as ${profile} ${if releaseType == "escript"
                                            then "escriptize"
                                            else "release"}
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      dir=${if releaseType == "escript"
            then "bin"
            else "rel"}
      mkdir -p "$out/$dir"
      cp -R --preserve=mode "_build/${profile}/$dir" "$out"
      runHook postInstall
    '';

    meta = {
      inherit (erlang.meta) platforms;
    } // meta;

    passthru = {
      packageName = name;
      env = shell self;
   };
  } // customPhases);
in
  fix pkg
