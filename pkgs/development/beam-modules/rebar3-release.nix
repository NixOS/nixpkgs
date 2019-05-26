{ stdenv, writeText, erlang, rebar3, openssl, libyaml,
  pc, lib }:

{ name, version
, src
, checkouts ? null
, releaseType
, buildInputs ? []
, setupHook ? null
, profile ? "default"
, installPhase ? null
, buildPhase ? null
, configurePhase ? null
, meta ? {}
, enableDebugInfo ? false
, ... }@attrs:

with stdenv.lib;

let
  debugInfoFlag = lib.optionalString (enableDebugInfo || erlang.debugInfo) "debug-info";

  shell = drv: stdenv.mkDerivation {
          name = "interactive-shell-${drv.name}";
          buildInputs = [ drv ];
    };

  customPhases = filterAttrs
    (_: v: v != null)
    { inherit setupHook configurePhase buildPhase installPhase; };

  pkg = self: stdenv.mkDerivation (attrs // {

    name = "${name}-${version}";
    inherit version;

    buildInputs = buildInputs ++ [ erlang rebar3 openssl ];
    propagatedBuildInputs = [checkouts];

    dontStrip = true;

    inherit src;

    setupHook = writeText "setupHook.sh" ''
       addToSearchPath ERL_LIBS "$1/lib/erlang/lib/"
    '';

    configurePhase = ''
      runHook preConfigure
      ${if checkouts != null then
          ''cp --no-preserve=all -R ${checkouts}/_checkouts .''
        else
          ''''}
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      HOME=. DEBUG=1 rebar3 as ${profile} ${if releaseType == "escript"
                                            then '' escriptize''
                                            else '' release''}
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      dir=${if releaseType == "escript"
            then ''bin''
            else ''rel''}
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
