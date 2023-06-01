{ stdenv, writeText, elixir, erlang, hex, lib }:

{ name
, version
, src
, buildInputs ? [ ]
, nativeBuildInputs ? [ ]
, beamDeps ? [ ]
, propagatedBuildInputs ? [ ]
, postPatch ? ""
, compilePorts ? false
, meta ? { }
, enableDebugInfo ? false
, mixEnv ? "prod"
, ...
}@attrs:

let
  shell = drv: stdenv.mkDerivation {
    name = "interactive-shell-${drv.name}";
    buildInputs = [ drv ];
  };

  pkg = self: stdenv.mkDerivation (attrs // {
    name = "${name}-${version}";
    inherit version src;

    MIX_ENV = mixEnv;
    MIX_DEBUG = if enableDebugInfo then 1 else 0;
    HEX_OFFLINE = 1;

    # add to ERL_LIBS so other modules can find at runtime.
    # http://erlang.org/doc/man/code.html#code-path
    # Mix also searches the code path when compiling with the --no-deps-check flag
    setupHook = attrs.setupHook or
      writeText "setupHook.sh" ''
      addToSearchPath ERL_LIBS "$1/lib/erlang/lib"
    '';

    buildInputs = buildInputs ++ [ ];
    nativeBuildInputs = nativeBuildInputs ++ [ elixir hex ];
    propagatedBuildInputs = propagatedBuildInputs ++ beamDeps;

    configurePhase = attrs.configurePhase or ''
      runHook preConfigure

      ${./mix-configure-hook.sh}

      runHook postConfigure
    '';

    buildPhase = attrs.buildPhase or ''
      runHook preBuild
      export HEX_HOME="$TEMPDIR/hex"
      export MIX_HOME="$TEMPDIR/mix"
      mix compile --no-deps-check
      runHook postBuild
    '';

    installPhase = attrs.installPhase or ''
      runHook preInstall

      # This uses the install path convention established by nixpkgs maintainers
      # for all beam packages. Changing this will break compatibility with other
      # builder functions like buildRebar3 and buildErlangMk.
      mkdir -p "$out/lib/erlang/lib/${name}-${version}"

      # Some packages like db_connection will use _build/shared instead of
      # honoring the $MIX_ENV variable.
      for reldir in _build/{$MIX_ENV,shared}/lib/${name}/{src,ebin,priv,include} ; do
        if test -d $reldir ; then
          # Some builds produce symlinks (eg: phoenix priv dircetory). They must
          # be followed with -H flag.
          cp  -Hrt "$out/lib/erlang/lib/${name}-${version}" "$reldir"
        fi
      done

      runHook postInstall
    '';

    # stripping does not have any effect on beam files
    # it is however needed for dependencies with NIFs like bcrypt for example
    dontStrip = false;

    passthru = {
      packageName = name;
      env = shell self;
      inherit beamDeps;
    };
  });
in
lib.fix pkg

