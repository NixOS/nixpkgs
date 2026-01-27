{
  elixir,
  erlang,
  hex,
  beamCopySourceHook,
  beamModuleInstallHook,
  mixBuildDirHook,
  mixCompileHook,
  mixConfigPatchHook,

  lib,
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
      mixEnv ? "prod",
      mixTarget ? "host",
      enableDebugInfo ? false,
      # Allow passing compile time config
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
      name = "erlang${erlang.version}-${args.name}-${finalAttrs.version}";

      env = {
        ERL_COMPILER_OPTIONS =
          let
            options = erlangCompilerOptions ++ lib.optionals erlangDeterministicBuilds [ "deterministic" ];
          in
          "[${lib.concatStringsSep "," options}]";

        MIX_ENV = mixEnv;
        MIX_TARGET = mixTarget;
        MIX_BUILD_PREFIX = (if mixTarget == "host" then "" else "${mixTarget}_") + "${mixEnv}";
        MIX_DEBUG = if enableDebugInfo then 1 else 0;
        HEX_OFFLINE = 1;

        LANG = if stdenv.hostPlatform.isLinux then "C.UTF-8" else "C";
        LC_CTYPE = if stdenv.hostPlatform.isLinux then "C.UTF-8" else "UTF-8";

        __darwinAllowLocalNetworking = true;

        # some hooks need name-version, but we've overridden name above for the nix package
        beamModuleName = args.name;
      };

      # add to ERL_LIBS so other modules can find at runtime.
      # http://erlang.org/doc/man/code.html#code-path
      # Mix also searches the code path when compiling with the --no-deps-check flag
      # This is used by package builders such as mixRelease
      setupHook = writeText "setupHook.sh" ''
        addToSearchPath ERL_LIBS "$1/lib/erlang/lib"
      '';

      nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
        elixir
        hex

        beamCopySourceHook
        beamModuleInstallHook
        mixBuildDirHook
        mixCompileHook
        mixConfigPatchHook
      ];

      propagatedBuildInputs = (args.propagatedBuildInputs or [ ]) ++ beamDeps;

      passthru = (args.passthru or { }) // {
        inherit beamDeps;
      };
    };
}
