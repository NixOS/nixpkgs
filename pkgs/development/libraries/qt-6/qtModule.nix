{ lib, mkDerivation, perl, cmake }:

let inherit (lib) licenses maintainers platforms; in

{ self, srcs, patches }:

argsRaw:

let
  # TODO? disable setting args.outputs manually, allow only args.hasPlugins
  args = { hasPlugins = false; } // argsRaw;
  inherit (args) pname;
  version = args.version or srcs.${pname}.version;
  src = args.src or srcs.${pname}.src;
in

mkDerivation (args // {
  inherit pname version src;
  patches = args.patches or patches.${pname} or [];

  nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ perl cmake ];
  propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or []);

  outputs = args.outputs or [ "out" "dev" ] ++ lib.optional args.hasPlugins "bin";
  setOutputFlags = args.setOutputFlags or false;

  # FIXME only needed for qt6
  # set attributes for qt-6/hooks/qmake-hook.sh
  # TODO better. we do not want to set this for every libsForQt6.callPackage target
  inherit (self.qtbase) qtDocPrefix qtQmlPrefix qtPluginPrefix;

  preHook = ''
    . ${./hooks/move-qt-dev-tools.sh}
    . ${./hooks/fix-qt-builtin-paths.sh}
  '';

  preConfigure = ''
    ${args.preConfigure or ""}

    fixQtBuiltinPaths . '*.pr?'
  '';

  dontWrapQtApps = args.dontWrapQtApps or true;

  # TODO verify for qt6: patching of pkgconfig files
  # TODO test before buildPhase if the module will produce plugins
  postFixup = ''
    if [ -d "''${!outputDev}/lib/pkgconfig" ]; then
        find "''${!outputDev}/lib/pkgconfig" -name '*.pc' | while read pc; do
            sed -i "$pc" \
                -e "/^prefix=/ c prefix=''${!outputLib}" \
                -e "/^exec_prefix=/ c exec_prefix=''${!outputBin}" \
                -e "/^includedir=/ c includedir=''${!outputDev}/include"
        done
    fi

    # TODO refactor. same code in qtbase.nix
    echo "patching output paths in cmake files ..."
    (
    cd $dev/lib/cmake
    moduleNAME="${lib.toUpper pname}"
    outEscaped=$(echo $out | sed 's,/,\\/,g')
    devEscaped=$(echo $dev | sed 's,/,\\/,g')
    if [ -n "$bin" ]; then
    binEscaped=$(echo $bin | sed 's,/,\\/,g') # optional plugins
    else binEscaped=""; fi

    # TODO build the perlRegex string with nix?
    perlRegex="s/^# Compute the installation prefix relative to this file\..*?set\(_IMPORT_PREFIX \"\"\)\nendif\(\)/# NixOS was here\nset(_''${moduleNAME}_NIX_OUT \"$outEscaped\")\nset(_''${moduleNAME}_NIX_DEV \"$devEscaped\")\nset(_''${moduleNAME}_NIX_BIN \"$binEscaped\")/s;"
    perlRegex+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?include/\\\''${_''${moduleNAME}_NIX_DEV}\/include/g;"
    perlRegex+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?libexec/\\\''${_''${moduleNAME}_NIX_DEV}\/libexec/g;" # both in $dev and $out, should be only in $dev, maybe
    perlRegex+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?lib/\\\''${_''${moduleNAME}_NIX_OUT}\/lib/g;" # must come after libexec
    perlRegex+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?plugins/\\\''${_''${moduleNAME}_NIX_BIN}\/lib\/qt-${version}\/plugins/g;"
    perlRegex+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?bin/\\\''${_''${moduleNAME}_NIX_DEV}\/bin/g;"
    perlRegex+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?mkspecs/\\\''${_''${moduleNAME}_NIX_OUT}\/mkspecs/g;" # should be in $dev, maybe
    perlRegex+="s/set\(_IMPORT_PREFIX\)/set(_''${moduleNAME}_NIX_OUT)\nset(_''${moduleNAME}_NIX_DEV)\nset(_''${moduleNAME}_NIX_BIN)/g;"

    echo "debug: perlRegex = $perlRegex"
    find . -name '*.cmake' -exec perl -00 -p -i -e "$perlRegex" '{}' \;
    echo "rc of find = $?" # zero when perl returns nonzero?
    # FIXME catch errors from perl: find -> xargs
    echo "patching output paths in cmake files done"

    echo "verify that all _IMPORT_PREFIX are replaced ..."
    matches="$(find . -name '*.cmake' -exec grep -HnF _IMPORT_PREFIX '{}' \;)"
    if [ -n "$matches" ]; then
      echo "fatal: _IMPORT_PREFIX was not replaced in:"
      echo "$matches"
      exit 1
    fi
    echo "verify that all _IMPORT_PREFIX are replaced done"
    )

    moveQtDevTools

    if [ -d $out/plugins ]; then
      if [ -z "$bin" ]; then
        echo 'fatal error: qt module has plugins but no "bin" output'
        echo 'listing plugins ...'
        find $out/plugins
        echo 'listing plugins done'
        echo 'todo: in qtModule for ${pname}-${version}, set:'
        echo '  hasPlugins = true;'
        echo 'or set:'
        echo '  outputs = [ "out" "dev" "bin" ];'
        exit 1
      fi
      echo "moving plugins to $bin/lib/qt-${self.qtbase.version}/plugins"
      mkdir -p $bin/lib/qt-${self.qtbase.version}
      mv $out/plugins $bin/lib/qt-${self.qtbase.version}
    elif [ -n "$bin" ]; then
      echo 'fatal error: qt module has no plugins but "bin" output'
      echo 'todo: in qtModule for ${pname}-${version}, remove:'
      echo '  hasPlugins = true;'
      echo 'or remove:'
      echo '  outputs = [ "out" "dev" "bin" ];'
    fi

    ${args.postFixup or ""}
  '';

  meta = {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ qknight ttuegel periklis bkchr ];
    platforms = platforms.unix;
  } // (args.meta or {});
})
