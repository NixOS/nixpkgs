{ qtModule
, qtbase
, qtdeclarative
, qtsvg
, hunspell
, pkg-config # find hunspell

, lib # debug
}:

# TODO optional dependencies?
# CerenceHwrAlphabetic
# CerenceHwrCjk
# CerenceXt9
# MyScript

qtModule {
  pname = "qtvirtualkeyboard";
  qtInputs = [ qtbase qtdeclarative qtsvg ];
  propagatedBuildInputs = [ hunspell ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "bin" ];



  # TODO debug cycle error
  splitBuildInstall = let
    # set vars for postFixup
    patch-cmake-files-sh = ../patch-cmake-files.sh;
    patch-cmake-files-regex-diff = ../patch-cmake-files.regex.diff;
    self.qtbase.version = version;
    pname = "qtvirtualkeyboard";
    version = "6.2.2";
    qtCompatVersion = version;
  in {

    # copy-paste from qtModule
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



      echo TODO debug cycle error



      echo "bin -> grep out -> ?"
      find $bin -type f -print0 | xargs -0 grep -F $(basename $out | cut -c1-32)
      # $bin/lib/qt-6.2.2/plugins/**/*.so: binary file matches -> ok

      echo "out -> grep bin -> ?"
      find $out -type f -print0 | xargs -0 grep -F $(basename $bin | cut -c1-32) || true
      # no matches -> should be no cycle 0__o

      echo "bin -> ldd -> ?"
      find $bin -name '*.so' -exec ldd '{}' ';' | cut -d' ' -f3 | sort | uniq | grep qtvirtualkeyboard
      # $out/lib/libQt6HunspellInputMethod.so.6
      # $out/lib/libQt6VirtualKeyboard.so.6

      echo "out -> ldd -> ?"
      (
        ldd $out/lib/libQt6HunspellInputMethod.so.6
        ldd $out/lib/libQt6VirtualKeyboard.so.6
      ) | cut -d' ' -f3 | sort | uniq | grep qtvirtualkeyboard
      # $out/lib/libQt6VirtualKeyboard.so.*

      echo "symlinks out -> ?"
      find $out -type l -print0 | xargs -0 ls -l -d
      # $out/lib/libQt6VirtualKeyboard.so.6

      echo "symlinks bin -> ?"
      find $bin -type l -print0 | xargs -0 ls -l -d
      # nothing


      if false; then
        echo ls $bin; ls $bin
        echo ls $out; ls $out
        echo ls $out/lib; ls $out/lib
        echo find $bin; find $bin
        mkdir -v $out/bin-todo-cycle-error
        echo "move $bin/* to $out/bin-todo-cycle-error/"
        mv -v $bin/* $out/bin-todo-cycle-error/
      fi

      echo rpath in bin
      patchelf --print-rpath $bin/lib/qt-6.2.2/plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so | tr : '\n'
      # -> has $out



      echo WORKAROUND cycle error

      #mv -v $bin/lib/qt-${self.qtbase.version} $out/lib/
      #ln -v -s $out/lib/qt-${self.qtbase.version} $bin/lib/
      # -> cycle error

      cp $out/lib/libQt6HunspellInputMethod.so.6 $bin/lib/
      cp $out/lib/libQt6VirtualKeyboard.so.6 $bin/lib/

      # remove $out from rpath in $bin
      find $bin -type f -name '*.so*' | while read f
      do
        a=$(patchelf --print-rpath "$f" | tr : '\n')
        b=$(echo "$a" | grep -v "$out" | tr '\n' :)
        patchelf --set-rpath "$b" "$f"
      done
      # building '/nix/store/v8i5q36a4ywrgfaa46amyklgria4yk63-qt-full-6.2.2.drv'...
      # error: collision between
      # `/nix/store/s7xbm0p7hcwj4jrbp7fidg0zhr6b9y13-qtvirtualkeyboard-6.2.2    /lib/libQt6VirtualKeyboard.so.6' and
      # `/nix/store/g8rbk52z0qws3pcifmlbq81y5rnda78g-qtvirtualkeyboard-6.2.2-bin/lib/libQt6VirtualKeyboard.so.6'
    '';

  };

}
