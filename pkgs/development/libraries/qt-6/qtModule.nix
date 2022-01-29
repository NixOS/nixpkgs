/*
FIXME qimgv (etc) should not require $dev packages
$bin paths are ok, they are needed for plugins
*/

{ lib, mkDerivation, perl, cmake, writeText }:

{ self, srcs, patches ? [] }:

argsRaw:

let
  # TODO maybe rename: splitBuildInstall -> splitInstall
  # the splitInstall attrset holds all attributes
  # for "drv2" = the "install from cached build" derivation
  argsFull = { splitBuildInstall = null; } // argsRaw;
  args = builtins.removeAttrs argsFull [ "splitBuildInstall" ];
  splitBuildInstallEnabled = argsFull.splitBuildInstall != null;
  inherit (args) pname;
  version = args.version or srcs.${pname}.version;
  src = args.src or srcs.${pname}.src;

  patch-cmake-files-sh = ./patch-cmake-files.sh;
  patch-cmake-files-regex-diff = ./patch-cmake-files.regex.diff;

  qtCompatVersion = self.qtbase.qtCompatVersion;
in

let
drv1 = mkDerivation (args // {

  # when splitting, disable all phases after buildPhase
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/setup.sh#L1305
  dontCheck = splitBuildInstallEnabled;
  dontInstall = splitBuildInstallEnabled;
  dontFixup = splitBuildInstallEnabled;
  dontInstallCheck = splitBuildInstallEnabled;
  dontDist = splitBuildInstallEnabled;
  postPhases = if splitBuildInstallEnabled then "splitBuildInstallLoad splitBuildInstallExport" else "";

  # TODO better? how to load "hooks" for mkDerivation?
  splitBuildInstallLoad = ''
    . ${./split-build-install.export.sh}
  '';
  # FIXME this is slow: splitBuildInstallExport: storing variables
  # -> parallel regex + track modified files (splitBuildInstall.patchedFiles.txt)
  # or faster to patch all files?

  inherit pname version src;
  patches = args.patches or patches.${pname} or [];

  nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ perl cmake ];
  propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or []);

  outputs = args.outputs or [ "out" "dev" ];
  setOutputFlags = args.setOutputFlags or false;

  # FIXME only needed for qt6
  # set attributes for qt-6/hooks/qmake-hook.sh
  # TODO better. we do not want to set this for every libsForQt6.callPackage target
  inherit (self.qtbase) qtDocPrefix qtQmlPrefix qtPluginPrefix;

  preHook = ''
    . ${./hooks/move-qt-dev-tools.sh}
    . ${./hooks/fix-qt-builtin-paths.sh}
  '';

  # help cmake to find $dev/lib/cmake
  setupHook = writeText "setup-hook.sh" ''
    echo "setupHook of ${pname}: add to QT_ADDITIONAL_PACKAGES_PREFIX_PATH: $1"
    export "QT_ADDITIONAL_PACKAGES_PREFIX_PATH=''${QT_ADDITIONAL_PACKAGES_PREFIX_PATH:+''${QT_ADDITIONAL_PACKAGES_PREFIX_PATH}:}$1"
  '';

  preConfigure = ''
    ${args.preConfigure or ""}

    fixQtBuiltinPaths . '*.pr?'
  '';

  dontWrapQtApps = args.dontWrapQtApps or true;

  # https://stackoverflow.com/a/70875733/10440128

  # TODO verify for qt6: patching of pkgconfig files
  # TODO test before buildPhase if the module will produce plugins
  # FIXME cycle error: mv $out/plugins $bin/lib/qt-${self.qtbase.version}
  postFixup = ''
    if [ -d "''${!outputDev}/lib/pkgconfig" ]; then
        find "''${!outputDev}/lib/pkgconfig" -name '*.pc' | while read pc; do
            sed -i "$pc" \
                -e "/^prefix=/ c prefix=''${!outputLib}" \
                -e "/^exec_prefix=/ c exec_prefix=''${!outputBin}" \
                -e "/^includedir=/ c includedir=''${!outputDev}/include"
        done
    fi

    if [ -d $dev/lib/cmake ]; then
      echo "patching output paths in $dev/lib/cmake ..."
      find $dev/lib/cmake -name '*.cmake' -print0 \
        | xargs -0 ${patch-cmake-files-sh} \
        qtCompatVersion=${qtCompatVersion} \
        QT_MODULE_NAME=${lib.toUpper pname} \
        NIX_OUT_PATH=$out \
        NIX_DEV_PATH=$dev \
        NIX_BIN_PATH=$bin \
        REGEX_FILE=${patch-cmake-files-regex-diff} --
      echo "patching output paths in $dev/lib/cmake done"
    fi

    if [ -d $out/bin ]; then
      # assume that all $out/bin are devTools
      echo "move $out/bin to $dev/bin"
      mkdir $dev || true
      mv $out/bin $dev/bin
    fi

    if [ -d $out/plugins ]; then
      if [ -z "$bin" ]; then
        echo 'FIXME qt module has plugins but no "bin" output'
      fi
      if false; then
        # WORKAROUND cycle error
        echo "symlinking plugins"${""/* FIXME cycle error: mv $out/plugins $bin/lib/qt-${self.qtbase.version} */}
        mkdir -p $bin/lib/qt-${self.qtbase.version}
        ln -s -v $out/plugins $bin/lib/qt-${self.qtbase.version}/plugins
      else
        # TODO test: cycle error?
        mkdir -p $bin/lib/qt-${self.qtbase.version}
        echo "moving plugins to $bin"
        mv $out/plugins $bin/lib/qt-${self.qtbase.version}/plugins
      fi
    elif [ -n "$bin" ]; then
      echo 'FIXME qt module has no plugins but "bin" output'
      echo '  -> in qtModule for ${pname}-${version}, remove bin from outputs'
    fi

    ${args.postFixup or ""}

    echo "verify that all _IMPORT_PREFIX are replaced ..."
    matches="$(find $dev/lib/cmake -name '*.cmake' -print0 | xargs -0 grep -HnF _IMPORT_PREFIX || true)"
    if [ -n "$matches" ]; then
      echo "fatal: _IMPORT_PREFIX was not replaced in:"
      echo "$matches"
      exit 1
    fi
    echo "verify that all _IMPORT_PREFIX are replaced done"
  '';

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ qknight ttuegel periklis bkchr milahu ];
    platforms = platforms.unix;
  } // (args.meta or {});
});
in

if (!splitBuildInstallEnabled) then drv1
else mkDerivation (drv1.drvAttrs // {
  src = drv1.out;
  prePhases = "splitBuildInstallLoad splitBuildInstallImport";
  postPhases = "";

  # TODO better? how to load "hooks" for mkDerivation?
  # separate script for import, to avoid rebuilds
  splitBuildInstallLoad = ''
    . ${./split-build-install.import.sh}
  '';

  # when splitting, disable all phases before buildPhase
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/setup.sh#L1305
  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  # enable all install phases
  dontCheck = false;
  dontInstall = false;
  dontFixup = false;
  dontInstallCheck = false;
  dontDist = false;

  # avoid rebuild
  installPhase = ''
    runHook preInstall
    cd /build/$sourceRoot/build
    cmake -P cmake_install.cmake
    runHook postInstall
  '';

} // argsFull.splitBuildInstall)
