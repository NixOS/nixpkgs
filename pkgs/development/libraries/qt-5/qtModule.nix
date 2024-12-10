{
  lib,
  stdenv,
  buildPackages,
  mkDerivation,
  apple-sdk_13,
  darwinMinVersionHook,
  perl,
  qmake,
  patches,
  srcs,
  pkgsHostTarget,
}:

let
  inherit (lib) licenses maintainers platforms;
in

args:

let
  inherit (args) pname;
  version = args.version or srcs.${pname}.version;
  src = args.src or srcs.${pname}.src;
in

mkDerivation (
  args
  // {
    inherit pname version src;
    patches = (args.patches or [ ]) ++ (patches.${pname} or [ ]);

    buildInputs =
      args.buildInputs or [ ]
      # Per https://doc.qt.io/qt-5/macos.html#supported-versions
      ++ lib.optionals stdenv.isDarwin [
        apple-sdk_13
        (darwinMinVersionHook "10.13")
      ];

    nativeBuildInputs =
      (args.nativeBuildInputs or [ ])
      ++ [
        perl
        qmake
      ]
      ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
        pkgsHostTarget.qt5.qtbase.dev
      ];
    propagatedBuildInputs =
      (lib.warnIf (args ? qtInputs) "qt5.qtModule's qtInputs argument is deprecated" args.qtInputs or [ ])
      ++ (args.propagatedBuildInputs or [ ]);
  }
  // lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
    depsBuildBuild = [ buildPackages.stdenv.cc ] ++ (args.depsBuildBuild or [ ]);
  }
  // {

    outputs =
      args.outputs or [
        "out"
        "dev"
      ];
    setOutputFlags = args.setOutputFlags or false;

    preHook = ''
      . ${./hooks/move-qt-dev-tools.sh}
      . ${./hooks/fix-qt-builtin-paths.sh}
    '';

    preConfigure =
      ''
        ${args.preConfigure or ""}

        fixQtBuiltinPaths . '*.pr?'
      ''
      +
        lib.optionalString (builtins.compareVersions "5.15.0" version <= 0)
          # Note: We use ${version%%-*} to remove any tag from the end of the version
          # string. Version tags are added by Nixpkgs maintainers and not reflected in
          # the source version.
          ''
            if [[ -z "$dontCheckQtModuleVersion" ]] \
                && grep -q '^MODULE_VERSION' .qmake.conf 2>/dev/null \
                && ! grep -q -F "''${version%%-*}" .qmake.conf 2>/dev/null
            then
              echo >&2 "error: could not find version ''${version%%-*} in .qmake.conf"
              echo >&2 "hint: check .qmake.conf and update the package version in Nixpkgs"
              exit 1
            fi

            if [[ -z "$dontSyncQt" && -f sync.profile ]]; then
              syncqt.pl -version "''${version%%-*}"
            fi
          '';

    dontWrapQtApps = args.dontWrapQtApps or true;

    postFixup = ''
      if [ -d "''${!outputDev}/lib/pkgconfig" ]; then
          find "''${!outputDev}/lib/pkgconfig" -name '*.pc' | while read pc; do
              sed -i "$pc" \
                  -e "/^prefix=/ c prefix=''${!outputLib}" \
                  -e "/^exec_prefix=/ c exec_prefix=''${!outputBin}" \
                  -e "/^includedir=/ c includedir=''${!outputDev}/include"
          done
      fi

      moveQtDevTools

      ${args.postFixup or ""}
    '';

    meta = {
      homepage = "https://www.qt.io";
      description = "Cross-platform application framework for C++";
      license = with licenses; [
        fdl13Plus
        gpl2Plus
        lgpl21Plus
        lgpl3Plus
      ];
      maintainers = with maintainers; [
        qknight
        ttuegel
        periklis
        bkchr
      ];
      platforms = platforms.unix;
    } // (args.meta or { });
  }
)
