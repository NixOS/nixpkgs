{
  stdenv, lib, copyPathsToStore,
  src, version,

  coreutils, bison, flex, gdb, gperf, lndir, patchelf, perl, pkgconfig, python2,
  ruby,

  dbus, fontconfig, freetype, glib, gtk3, harfbuzz, icu, libX11, libXcomposite,
  libXcursor, libXext, libXi, libXrender, libinput, libjpeg, libpng, libtiff,
  libxcb, libxkbcommon, libxml2, libxslt, openssl, pcre16, sqlite, udev,
  xcbutil, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, xcbutilwm, xlibs,
  zlib,

  # optional dependencies
  cups ? null, mysql ? null, postgresql ? null,

  # options
  mesaSupported, mesa,
  buildExamples ? false,
  buildTests ? false,
  developerBuild ? false,
  decryptSslTraffic ? false
}:

let
  system-x86_64 = lib.elem stdenv.system lib.platforms.x86_64;
in

stdenv.mkDerivation {

  name = "qtbase-${version}";
  inherit src version;

  outputs = [ "out" "dev" ];

  patches =
    copyPathsToStore (lib.readPathsFromFile ./. ./series)
    ++ lib.optional decryptSslTraffic ./decrypt-ssl-traffic.patch
    ++ lib.optional mesaSupported [ ./dlopen-gl.patch ./mkspecs-libgl.patch ];

  postPatch =
    ''
      substituteInPlace configure --replace /bin/pwd pwd
      substituteInPlace src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
      sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i mkspecs/*/*.conf

      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "src/corelib/Qt5Config.cmake.in"
      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "src/corelib/Qt5CoreMacros.cmake"
      sed -i 's/NO_DEFAULT_PATH//' "src/gui/Qt5GuiConfigExtras.cmake.in"
      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "mkspecs/features/data/cmake/Qt5BasicConfig.cmake.in"

      substituteInPlace src/network/kernel/qdnslookup_unix.cpp \
        --replace "@glibc@" "${stdenv.cc.libc.out}"
      substituteInPlace src/network/kernel/qhostinfo_unix.cpp \
        --replace "@glibc@" "${stdenv.cc.libc.out}"

      substituteInPlace src/plugins/platforms/xcb/qxcbcursor.cpp \
        --replace "@libXcursor@" "${libXcursor.out}"

      substituteInPlace src/network/ssl/qsslsocket_openssl_symbols.cpp \
        --replace "@openssl@" "${openssl.out}"

      substituteInPlace src/dbus/qdbus_symbols.cpp \
        --replace "@dbus_libs@" "${dbus.lib}"

      substituteInPlace \
        src/plugins/platforminputcontexts/compose/generator/qtablegenerator.cpp \
        --replace "@libX11@" "${libX11.out}"
    ''
    + lib.optionalString mesaSupported ''
      substituteInPlace \
        src/plugins/platforms/xcb/gl_integrations/xcb_glx/qglxintegration.cpp \
        --replace "@mesa_lib@" "${mesa.out}"
      substituteInPlace mkspecs/common/linux.conf \
        --replace "@mesa_lib@" "${mesa.out}" \
        --replace "@mesa_inc@" "${mesa.dev or mesa}"
    '';


  setOutputFlags = false;
  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/lib:$PWD/plugins/platforms:$LD_LIBRARY_PATH"
    export MAKEFLAGS=-j$NIX_BUILD_CORES

    configureFlags+="\
        -plugindir $out/lib/qt5/plugins \
        -importdir $out/lib/qt5/imports \
        -qmldir $out/lib/qt5/qml \
        -docdir $out/share/doc/qt5"
  '';

  prefixKey = "-prefix ";

  # -no-eglfs, -no-directfb, -no-linuxfb and -no-kms because of the current minimalist mesa
  # TODO Remove obsolete and useless flags once the build will be totally mastered
  configureFlags = ''
    -verbose
    -confirm-license
    -opensource

    -release
    -shared
    ${lib.optionalString developerBuild "-developer-build"}
    -accessibility
    -rpath
    -strip
    -no-reduce-relocations
    -system-proxies
    -pkg-config

    -gui
    -widgets
    -opengl desktop
    -qml-debug
    -icu
    -pch
    -glib
    -xcb
    -qpa xcb
    -${lib.optionalString (cups == null) "no-"}cups

    -no-eglfs
    -no-directfb
    -no-linuxfb
    -no-kms

    ${lib.optionalString (!system-x86_64) "-no-sse2"}
    -no-sse3
    -no-ssse3
    -no-sse4.1
    -no-sse4.2
    -no-avx
    -no-avx2
    -no-mips_dsp
    -no-mips_dspr2

    -system-zlib
    -system-libpng
    -system-libjpeg
    -system-harfbuzz
    -system-xcb
    -system-xkbcommon
    -system-pcre
    -openssl-linked
    -dbus-linked
    -libinput
    -gtk

    -system-sqlite
    -${if mysql != null then "plugin" else "no"}-sql-mysql
    -${if postgresql != null then "plugin" else "no"}-sql-psql

    -make libs
    -make tools
    -${lib.optionalString (buildExamples == false) "no"}make examples
    -${lib.optionalString (buildTests == false) "no"}make tests
    -v
  '';

  # PostgreSQL autodetection fails sporadically because Qt omits the "-lpq" flag
  # if dependency paths contain the string "pq", which can occur in the hash.
  # To prevent these failures, we need to override PostgreSQL detection.
  PSQL_LIBS = lib.optionalString (postgresql != null) "-L${postgresql.lib}/lib -lpq";

  propagatedBuildInputs = [
    dbus glib libxml2 libxslt openssl pcre16 sqlite udev zlib

    # Image formats
    libjpeg libpng libtiff

    # Text rendering
    fontconfig freetype harfbuzz icu

    # X11 libs
    libX11 libXcomposite libXext libXi libXrender libxcb libxkbcommon xcbutil
    xcbutilimage xcbutilkeysyms xcbutilrenderutil xcbutilwm
  ]
  ++ lib.optional mesaSupported mesa;

  buildInputs =
    [ gtk3 libinput ]
    ++ lib.optional developerBuild gdb
    ++ lib.optional (cups != null) cups
    ++ lib.optional (mysql != null) mysql.lib
    ++ lib.optional (postgresql != null) postgresql;

  nativeBuildInputs =
    [ bison flex gperf lndir patchelf perl pkgconfig python2 ];

  # freetype-2.5.4 changed signedness of some struct fields
  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare";

  postInstall = ''
    find "$out" -name "*.cmake" | while read file; do
        substituteInPlace "$file" \
            --subst-var-by NIX_OUT "$out" \
            --subst-var-by NIX_DEV "$dev"
    done
  '';

  preFixup = ''
    # We cannot simply set these paths in configureFlags because libQtCore retains
    # references to the paths it was built with.
    moveToOutput "bin" "$dev"
    moveToOutput "include" "$dev"
    moveToOutput "mkspecs" "$dev"

    # The destination directory must exist or moveToOutput will do nothing
    mkdir -p "$dev/share"
    moveToOutput "share/doc" "$dev"
  '';

  postFixup =
    ''
      # Don't retain build-time dependencies like gdb.
      sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri

      # Move libtool archives and qmake projects
      if [ "z''${!outputLib}" != "z''${!outputDev}" ]; then
          pushd "''${!outputLib}"
          find lib -name '*.a' -o -name '*.la' -o -name '*.prl' | \
              while read -r file; do
                  mkdir -p "''${!outputDev}/$(dirname "$file")"
                  mv "''${!outputLib}/$file" "''${!outputDev}/$file"
              done
          popd
      fi
    ''

    # fixup .pc file (where to find 'moc' etc.)
    + lib.optionalString (!stdenv.isDarwin) ''
      sed -i "$dev/lib/pkgconfig/Qt5Core.pc" \
          -e "/^host_bins=/ c host_bins=$dev/bin"
    ''

    # Don't move .prl files on darwin because they end up in
    # "dev/lib/Foo.framework/Foo.prl" which interferes with subsequent
    # use of lndir in the qtbase setup-hook. On Linux, the .prl files
    # are in lib, and so do not cause a subsequent recreation of deep
    # framework directory trees.
    + lib.optionalString stdenv.isDarwin ''
      fixDarwinDylibNames_rpath() {
        local flags=()

        for fn in "$@"; do
          flags+=(-change "@rpath/$fn.framework/Versions/5/$fn" "$out/lib/$fn.framework/Versions/5/$fn")
        done

        for fn in "$@"; do
          echo "$fn: fixing dylib"
          install_name_tool -id "$out/lib/$fn.framework/Versions/5/$fn" "''${flags[@]}" "$out/lib/$fn.framework/Versions/5/$fn"
        done
      }
      fixDarwinDylibNames_rpath "QtConcurrent" "QtPrintSupport" "QtCore" "QtSql" "QtDBus" "QtTest" "QtGui" "QtWidgets" "QtNetwork" "QtXml" "QtOpenGL"
    '';

  inherit lndir;
  setupHook = if stdenv.isDarwin
              then ../../qtbase-setup-hook-darwin.sh
              else ../../qtbase-setup-hook.sh;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://www.qt.io;
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ bbenoist qknight ttuegel ];
    platforms = platforms.linux;
  };

}
