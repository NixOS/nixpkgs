{ qtModule
, qtbase
, libglvnd, libxkbcommon, vulkan-headers # TODO should be inherited from qtbase
, qtshadertools
, openssl
, python3

, lib # splitBuildInstall

#, openvg, openvg-headers
# https://bugreports.qt.io/browse/QTBUG-98040

}:

# TODO? qtModule rec { ... }
# -> in splitBuildInstall, can use pname, version

qtModule {
  pname = "qtdeclarative";
  qtInputs = [ qtbase qtshadertools ];
  buildInputs = [ openssl openssl.dev python3 /* openvg.shivavg openvg-headers */ libglvnd libxkbcommon vulkan-headers ];
  outputs = [ "out" "dev" "bin" ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QML2_IMPORT_PREFIX=\"$qtQmlPrefix\""
  '';
  configureFlags = [ "-qml-debug" ];
  # TODO build/?
  devTools = [
    "bin/qml"
    "bin/qmlcachegen"
    "bin/qmleasing"
    "bin/qmlimportscanner"
    "bin/qmllint"
    "bin/qmlmin"
    "bin/qmlplugindump"
    "bin/qmlprofiler"
    "bin/qmlscene"
    "bin/qmltestrunner"
  ];

  # debug: install is failing
  splitBuildInstall =
  let
    # workaround for splitBuildInstall
    pname = "qtdeclarative";
    version = "6.2.2";
    self = { inherit qtbase; };
    args = { postFixup = ""; };
  in
  {
    # needed to disable rebuild
    # TODO simpler way? cmake hooks trigger rebuild?
    /*
    installPhase = ''
      cmake -P cmake_install.cmake
    '';
    */


  # copy from nixpkgs/pkgs/development/libraries/qt-6/qtModule.nix
  # TODO move back when working
  postFixup = ''
    if [ -d "''${!outputDev}/lib/pkgconfig" ]; then
        find "''${!outputDev}/lib/pkgconfig" -name '*.pc' | while read pc; do
            sed -i "$pc" \
                -e "/^prefix=/ c prefix=''${!outputLib}" \
                -e "/^exec_prefix=/ c exec_prefix=''${!outputBin}" \
                -e "/^includedir=/ c includedir=''${!outputDev}/include"
        done
    fi

    # TODO refactor. same code in qtbase.nix and qtModule.nix
    echo "patching output paths in cmake files ..."
    (
    cd $dev/lib/cmake
    moduleNAME="${lib.toUpper pname}"
    outEscaped=$(echo $out | sed 's,/,\\/,g')
    devEscaped=$(echo $dev | sed 's,/,\\/,g')
    if [ -n "$bin" ]; then
    binEscaped=$(echo $bin | sed 's,/,\\/,g') # optional plugins
    else binEscaped=""; fi

    # TODO build the perlRegex string with nix? avoid the bash escape hell
    # or use: read -d "" perlRegex <<EOF ... EOF
    s=""
    s+="s/^# Compute the installation prefix relative to this file\."
    s+="\n.*?set\(_IMPORT_PREFIX \"\"\)\nendif\(\)"
    s+="/# NixOS was here"
    s+="\nset(_''${moduleNAME}_NIX_OUT \"$outEscaped\")"
    s+="\nset(_''${moduleNAME}_NIX_DEV \"$devEscaped\")"
    s+="\nset(_''${moduleNAME}_NIX_BIN \"$binEscaped\")/s;"
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?include/\\\''${_''${moduleNAME}_NIX_DEV}\/include/g;"
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?libexec/\\\''${_''${moduleNAME}_NIX_OUT}\/libexec/g;"
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?lib/\\\''${_''${moduleNAME}_NIX_OUT}\/lib/g;" # must come after libexec
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?plugins/\\\''${_''${moduleNAME}_NIX_BIN}\/lib\/qt-${version}\/plugins/g;"

    # FIXME bin should be in NIX_DEV output
    # workaround for cycle error
    #s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?bin/\\\''${_''${moduleNAME}_NIX_DEV}\/bin/g;" # qmake, qmldom ...
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?bin/\\\''${_''${moduleNAME}_NIX_OUT}\/bin/g;" # qmake, qmldom ...

    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?mkspecs/\\\''${_''${moduleNAME}_NIX_DEV}\/mkspecs/g;"
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?qml/\\\''${_''${moduleNAME}_NIX_OUT}\/lib\/qt-${version}\/lib\/qml/g;"
    s+="s/set\(_IMPORT_PREFIX\)"
    s+="/set(_''${moduleNAME}_NIX_OUT)"
    s+="\nset(_''${moduleNAME}_NIX_DEV)"
    s+="\nset(_''${moduleNAME}_NIX_BIN)/g;"
    s+="s/\\\''${QtBase_SOURCE_DIR}\/libexec/\\\''${QtBase_BINARY_DIR}\/libexec/g;" # QtBase_SOURCE_DIR = qtbase/$dev

    s+="s/\\\''${QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX}\/\\\''${INSTALL_LIBEXECDIR}/$outEscaped\/libexec/g;"
    s+="s/\\\''${QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX}\/\\\''${INSTALL_BINDIR}/$devEscaped\/bin/g;"
    s+="s/\\\''${QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX}\/\\\''${INSTALL_DOCDIR}/$outEscaped\/share\/doc/g;"
    s+="s/\\\''${QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX}\/\\\''${INSTALL_LIBDIR}/$outEscaped\/lib/g;"
    s+="s/\\\''${QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX}\/\\\''${INSTALL_MKSPECSDIR}/$devEscaped\/mkspecs/g;"

    # lib/cmake/Qt6/QtBuild.cmake
    s+="s/\\\''${CMAKE_CURRENT_LIST_DIR}\/\.\.\/mkspecs/$devEscaped\/mkspecs/g;"
    # lib/cmake/Qt6/QtPriHelpers.cmake
    s+="s/\\\''${CMAKE_CURRENT_BINARY_DIR}\/mkspecs/$devEscaped\/mkspecs/g;"

    #s+="s/\\\''${QtBase_SOURCE_DIR}\/lib/\\\''${QtBase_BINARY_DIR}\/lib/g;" # TODO?
    perlRegex="$s"

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

    # wontfix? moving plugins from $out to $bin:
    # error: cycle detected in the references of output 'bin' from output 'out'
    # -> keep all qt plugins in $out? for consistency
    mkdir $bin || true
    if false; then
      if [ -d $out/plugins ]; then
        echo "found plugins in $out/plugins"
        ( cd $out/plugins; find . )
        if [ -z "$bin" ]; then
          echo 'fatal error: qt module has plugins but no "bin" output'
          echo 'listing plugins ...'
          find $out/plugins
          echo 'listing plugins done'
          echo 'todo: in qtModule for ${pname}-${version}, set:'
          echo '  outputs = [ "out" "dev" "bin" ];'
          exit 1
        fi
        echo "moving plugins to $bin/lib/qt-${self.qtbase.version}/plugins"
        mkdir -p $bin/lib/qt-${self.qtbase.version}
        mv $out/plugins $bin/lib/qt-${self.qtbase.version}
      elif [ -n "$bin" ]; then
        echo 'FIXME warning: qt module has no plugins but "bin" output'
        echo 'todo: in qtModule for ${pname}-${version}, remove:'
        echo '  outputs = [ "out" "dev" "bin" ];'
      fi
    fi

    ${args.postFixup or ""}
  '';

  installPhase = ''
    runHook preInstall
    cd /build/$sourceRoot/build
    cmake -P cmake_install.cmake
    runHook postInstall
  '';

  postInstall = ''
    find $out/lib/cmake -name '*Targets.cmake' | while read f
    do
      echo "patching cmake file $f"
      sed -i -E 's,INTERFACE_INCLUDE_DIRECTORIES,INTERFACE_LINK_DIRECTORIES "''${_QTDECLARATIVE_NIX_OUT}/lib" # NixOS was here\n  &,' "$f"
    done
  '';

  # TODO build/?
  devTools = [
    "build/bin/qml"
    "build/bin/qmlcachegen"
    "build/bin/qmleasing"
    "build/bin/qmlimportscanner"
    "build/bin/qmllint"
    "build/bin/qmlmin"
    "build/bin/qmlplugindump"
    "build/bin/qmlprofiler"
    "build/bin/qmlscene"
    "build/bin/qmltestrunner"
  ];


  };
}
