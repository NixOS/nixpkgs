{ stdenv, writeText, erlang, perl, which, gitMinimal, wget }:

{ name, version
, src
, setupHook ? null
, buildInputs ? []
, beamDeps ? []
, postPatch ? ""
, compilePorts ? false
, installPhase ? null
, meta ? {}
, ... }@attrs:

with stdenv.lib;

let
  shell = drv: stdenv.mkDerivation {
          name = "interactive-shell-${drv.name}";
          buildInputs = [ drv ];
    };

  pkg = self: stdenv.mkDerivation ( attrs // {
    app_name = "${name}";
    name = "${name}-${version}";
    inherit version;

    dontStrip = true;

    inherit src;

    setupHook = if setupHook == null
    then writeText "setupHook.sh" ''
       addToSearchPath ERL_LIBS "$1/lib/erlang/lib"
    ''
    else setupHook;

    buildInputs = [ erlang perl which gitMinimal wget ];
    propagatedBuildInputs = beamDeps;

    configurePhase = ''
      runHook preConfigure

      # We shouldnt need to do this, but it seems at times there is a *.app in
      # the repo/package. This ensures we start from a clean slate
      make SKIP_DEPS=1 clean

      runHook postConfigure
    '';

    buildPhase = ''
        runHook preBuild

        make SKIP_DEPS=1

        runHook postBuild
    '';

    installPhase = ''
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
    '';

    passthru = {
      packageName = name;
      env = shell self;
      inherit beamDeps;
    };
});
in fix pkg
