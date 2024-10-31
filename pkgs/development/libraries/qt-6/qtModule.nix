{
  lib,
  stdenv,
  apple-sdk_qt,
  cmake,
  ninja,
  perl,
  moveBuildTree,
  srcs,
  patches ? [ ],
}:

fnOrAttrs:

let
  transformArgs =
    finalAttrs: args:
    args
    // {

      version = args.version or srcs.${args.pname}.version;
      src = args.src or srcs.${args.pname}.src;

      patches = args.patches or patches.${args.pname} or [ ];

      buildInputs =
        args.buildInputs or [ ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_qt ];
      nativeBuildInputs =
        (args.nativeBuildInputs or [ ])
        ++ [
          cmake
          ninja
          perl
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [ moveBuildTree ];
      propagatedBuildInputs =
        (lib.warnIf (args ? qtInputs) "qt6.qtModule's qtInputs argument is deprecated" args.qtInputs or [ ])
        ++ (args.propagatedBuildInputs or [ ]);

      moveToDev = false;

      outputs =
        args.outputs or [
          "out"
          "dev"
        ];
      separateDebugInfo = args.separateDebugInfo or true;

      dontWrapQtApps = args.dontWrapQtApps or true;

      meta =
        with lib;
        let
          pos = builtins.unsafeGetAttrPos "pname" args;
        in
        {
          homepage = "https://www.qt.io/";
          description = "Cross-platform application framework for C++";
          license = with licenses; [
            fdl13Plus
            gpl2Plus
            lgpl21Plus
            lgpl3Plus
          ];
          maintainers = with maintainers; [
            milahu
            nickcao
          ];
          platforms = platforms.unix;
          position = "${pos.file}:${toString pos.line}";
        }
        // (args.meta or { });

    };
in

stdenv.mkDerivation (
  finalAttrs:
  let
    args = if lib.isFunction fnOrAttrs then fnOrAttrs (args' // finalAttrs) else fnOrAttrs;
    args' = transformArgs finalAttrs args;
  in
  args'
)
