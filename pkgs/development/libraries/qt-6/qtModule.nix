{
  lib,
  stdenv,
  darwinVersionInputs,
  cmake,
  ninja,
  perl,
  moveBuildTree,
  srcs,
  patches ? [ ],
}:

args:

let
  inherit (args) pname;
  version = args.version or srcs.${pname}.version;
  src = args.src or srcs.${pname}.src;
in
stdenv.mkDerivation (
  args
  // {
    inherit pname version src;
    patches = args.patches or patches.${pname} or [ ];

    buildInputs =
      args.buildInputs or [ ] ++ lib.optionals stdenv.hostPlatform.isDarwin darwinVersionInputs;
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

    cmakeFlags = [
      # be more verbose
      "--log-level=STATUS"
      # don't leak OS version into the final output
      # https://bugreports.qt.io/browse/QTBUG-136060
      "-DCMAKE_SYSTEM_VERSION="
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-DQT_NO_XCODE_MIN_VERSION_CHECK=ON"
      # This is only used for the min version check, which we disabled above.
      # When this variable is not set, cmake tries to execute xcodebuild
      # to query the version.
      "-DQT_INTERNAL_XCODE_VERSION=0.1"
    ]
    ++ args.cmakeFlags or [ ];

    moveToDev = false;

    outputs =
      args.outputs or [
        "out"
        "dev"
      ];
    separateDebugInfo = args.separateDebugInfo or true;

    dontWrapQtApps = args.dontWrapQtApps or true;
  }
)
// {
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
        nickcao
      ];
      platforms = platforms.unix;
      position = "${pos.file}:${toString pos.line}";
    }
    // (args.meta or { });
}
