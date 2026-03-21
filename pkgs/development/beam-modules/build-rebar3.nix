{
  erlang,
  beamCopySourceHook,
  beamModuleInstallHook,
  rebar3CompileHook,
  rebar3WithPlugins,
  rebarDevendorPatchHook,

  libyaml,
  openssl,

  lib,
  stdenv,
  writeText,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  excludeDrvArgNames = [
    "beamDeps"
    "buildPlugins"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      beamDeps ? [ ],
      buildPlugins ? [ ],

      enableDebugInfo ? false,
      erlangCompilerOptions ? [ ],
      # Deterministic Erlang builds remove full system paths from debug information
      # among other things to keep builds more reproducible. See their docs for more:
      # https://www.erlang.org/doc/man/compile
      erlangDeterministicBuilds ? true,
      ...
    }@args:
    let
      rebar3Custom = rebar3WithPlugins {
        plugins = buildPlugins;
      };
    in
    {
      pname = args.name;
      name = "erlang${erlang.version}-${args.name}-${finalAttrs.version}";

      nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
        rebarDevendorPatchHook
        beamCopySourceHook
        beamModuleInstallHook
        rebar3CompileHook
      ];

      buildInputs = (args.buildInputs or [ ]) ++ [
        erlang
        rebar3Custom
        openssl
        libyaml
      ];

      propagatedBuildInputs = lib.unique beamDeps;

      env = {
        ERL_COMPILER_OPTIONS =
          let
            options = erlangCompilerOptions ++ lib.optionals erlangDeterministicBuilds [ "deterministic" ];
          in
          "[${lib.concatStringsSep "," options}]";

        beamModuleName = args.name;
      };

      setupHook = writeText "setupHook.sh" ''
        addToSearchPath ERL_LIBS "$1/lib/erlang/lib/"
      '';

      meta = {
        inherit (erlang.meta) platforms;
      }
      // (args.meta or { });

      passthru = {
        inherit beamDeps;
      };
    };
}
