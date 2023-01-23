{ stdenv, lib, perl, cmake, ninja, writeText }:

{ self, srcs, patches ? [ ] }:

args:

let
  inherit (args) pname;
  version = args.version or srcs.${pname}.version;
  src = args.src or srcs.${pname}.src;
in
stdenv.mkDerivation (args // {
  inherit pname version src;
  patches = args.patches or patches.${pname} or [ ];

  buildInputs = args.buildInputs or [ ];
  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
    perl
    cmake
    ninja
    self.qmake
  ];
  propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or [ ]);

  preHook = ''
    . ${./hooks/move-qt-dev-tools.sh}
    . ${./hooks/fix-qt-builtin-paths.sh}
  '';

  outputs = args.outputs or [ "out" "dev" ];

  dontWrapQtApps = args.dontWrapQtApps or true;
  postInstall = ''
    if [ ! -z "$dev" ]; then
      mkdir "$dev"
      for dir in libexec mkspecs
      do
        moveToOutput "$dir" "$dev"
      done
    fi
    fixQtBuiltinPaths $out/lib "*.pr?"
    ${args.postInstall or ""}
  '';

  preConfigure = args.preConfigure or "" + ''
    fixQtBuiltinPaths . '*.pr?'
  '' + lib.optionalString (builtins.compareVersions "5.15.0" version <= 0)
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
        # FIXME: this probably breaks crosscompiling as it's not from nativeBuildInputs
        # I don't know how to get /libexec from nativeBuildInputs to work, it's not under /bin
        ${lib.getDev self.qtbase}/libexec/syncqt.pl -version "''${version%%-*}"
      fi
    '';

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
  '' + args.postFixup or "";

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13Plus gpl2Plus lgpl21Plus lgpl3Plus ];
    maintainers = with maintainers; [ milahu nickcao ];
    platforms = platforms.unix;
  } // (args.meta or { });
})
