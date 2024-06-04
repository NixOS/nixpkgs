{ stdenv, writeText, erlang, perl, which, gitMinimal, wget, lib }:

{ name
, version
, src
, setupHook ? null
, buildInputs ? [ ]
, beamDeps ? [ ]
, postPatch ? ""
, compilePorts ? false
, installPhase ? null
, buildPhase ? null
, configurePhase ? null
, meta ? { }
, enableDebugInfo ? false
, buildFlags ? [ ]
, ...
}@attrs:

let
  debugInfoFlag = lib.optionalString (enableDebugInfo || erlang.debugInfo) "+debug_info";

  shell = drv: stdenv.mkDerivation {
    name = "interactive-shell-${drv.name}";
    buildInputs = [ drv ];
  };

  pkg = self: stdenv.mkDerivation (attrs // {
    app_name = name;
    name = "${name}-${version}";
    inherit version;

    dontStrip = true;

    inherit src;

    setupHook =
      if setupHook == null
      then
        writeText "setupHook.sh" ''
          addToSearchPath ERL_LIBS "$1/lib/erlang/lib"
        ''
      else setupHook;

    buildInputs = buildInputs ++ [ erlang perl which gitMinimal wget ];
    propagatedBuildInputs = beamDeps;

    buildFlags = [ "SKIP_DEPS=1" ]
      ++ lib.optional (enableDebugInfo || erlang.debugInfo) ''ERL_OPTS="$ERL_OPTS +debug_info"''
      ++ buildFlags;

    configurePhase =
      if configurePhase == null
      then ''
        runHook preConfigure

        # We shouldnt need to do this, but it seems at times there is a *.app in
        # the repo/package. This ensures we start from a clean slate
        make SKIP_DEPS=1 clean

        runHook postConfigure
      ''
      else configurePhase;

    buildPhase =
      if buildPhase == null
      then ''
        runHook preBuild

        make $buildFlags "''${buildFlagsArray[@]}"

        runHook postBuild
      ''
      else buildPhase;

    installPhase =
      if installPhase == null
      then ''
        runHook preInstall

        mkdir -p $out/lib/erlang/lib/${name}
        cp -r ebin $out/lib/erlang/lib/${name}/
        cp -r src $out/lib/erlang/lib/${name}/

        if [ -d include ]; then
          cp -r include $out/lib/erlang/lib/${name}/
        fi

        if [ -d priv ]; then
          cp -r priv $out/lib/erlang/lib/${name}/
        fi

        if [ -d doc ]; then
          cp -r doc $out/lib/erlang/lib/${name}/
        fi

        runHook postInstall
      ''
      else installPhase;

    passthru = {
      packageName = name;
      env = shell self;
      inherit beamDeps;
    };
  });
in
lib.fix pkg
