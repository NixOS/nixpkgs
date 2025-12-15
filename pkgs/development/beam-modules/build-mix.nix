{
  elixir,
  erlang,
  hex,
  lib,
  mixConfigureHook,
  stdenv,
  writeText,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  excludeDrvArgNames = [
    "mixEnv"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      nativeBuildInputs ? [ ],
      propagatedBuildInputs ? [ ],
      passthru ? { },
      mixEnv ? "prod",
      mixTarget ? "host",
      enableDebugInfo ? false,
      # A handful of libraries require compile time configuration
      appConfigPath ? null,
      erlangCompilerOptions ? [ ],
      # Deterministic Erlang builds remove full system paths from debug information
      # among other things to keep builds more reproducible. See their docs for more:
      # https://www.erlang.org/doc/man/compile
      erlangDeterministicBuilds ? true,
      beamDeps ? [ ],
      ...
    }@args:
    {
      name = "erlang-${erlang.version}-${args.name}-${finalAttrs.version}";

      env = {
        MIX_ENV = mixEnv;
        MIX_TARGET = mixTarget;
        MIX_BUILD_PREFIX = (if mixTarget == "host" then "" else "${mixTarget}_") + "${mixEnv}";
        MIX_DEBUG = if enableDebugInfo then 1 else 0;
        HEX_OFFLINE = 1;
        ERL_COMPILER_OPTIONS =
          let
            options = erlangCompilerOptions ++ lib.optionals erlangDeterministicBuilds [ "deterministic" ];
          in
          "[${lib.concatStringsSep "," options}]";

        LANG = if stdenv.hostPlatform.isLinux then "C.UTF-8" else "C";
        LC_CTYPE = if stdenv.hostPlatform.isLinux then "C.UTF-8" else "UTF-8";
        __darwinAllowLocalNetworking = true;
      };

      # add to ERL_LIBS so other modules can find at runtime.
      # http://erlang.org/doc/man/code.html#code-path
      # Mix also searches the code path when compiling with the --no-deps-check flag
      # This is used by package builders such as mixRelease
      setupHook = writeText "setupHook.sh" ''
        addToSearchPath ERL_LIBS "$1/lib/erlang/lib"
      '';

      nativeBuildInputs = nativeBuildInputs ++ [
        elixir
        hex
        mixConfigureHook
      ];
      propagatedBuildInputs = propagatedBuildInputs ++ beamDeps;

      # We don't want to include whatever config a dependency brings; per
      # https://hexdocs.pm/elixir/main/Config.html, config is application specific.
      patchPhase =
        args.patchPhase or (
          ''
            runHook prePatch

            rm -rf config
          ''
          + lib.optionalString (!isNull appConfigPath) ''
            cp -r ${appConfigPath} config
          ''
          + ''
            runHook postPatch
          ''
        );

      buildPhase =
        args.buildPhase or ''
          runHook preBuild

          export HEX_HOME="$TEMPDIR/hex"
          export MIX_HOME="$TEMPDIR/mix"
          mix compile --no-deps-check

          runHook postBuild
        '';

      installPhase =
        args.installPhase or ''
          runHook preInstall

          # This uses the install path convention established by nixpkgs maintainers
          # for all beam packages. Changing this will break compatibility with other
          # builder functions like buildRebar3 and buildErlangMk.
          mkdir -p "$out/lib/erlang/lib/${finalAttrs.name}-${finalAttrs.version}-${args.version}"

          # Some packages like db_connection will use _build/shared instead of
          # honoring the $MIX_ENV variable.
          for reldir in _build/{$MIX_BUILD_PREFIX,shared}/lib/${finalAttrs.name}-${finalAttrs.version}/{src,ebin,priv,include} ; do
            if test -d $reldir ; then
              # Some builds produce symlinks (eg: phoenix priv dircetory). They must
              # be followed with -H flag.
              cp  -Hrt "$out/lib/erlang/lib/${finalAttrs.name}-${finalAttrs.version}" "$reldir"
            fi
          done

          runHook postInstall
        '';

      # stripping does not have any effect on beam files
      # it is however needed for dependencies with NIFs like bcrypt for example
      dontStrip = args.dontStrip or false;

      passthru = {
        inherit beamDeps;
      }
      // passthru;
    };
}
