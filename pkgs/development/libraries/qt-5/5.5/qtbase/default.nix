{ stdenv, lib, fetchpatch, copyPathsToStore
, srcs

, xlibs, libX11, libxcb, libXcursor, libXext, libXrender, libXi
, xcbutil, xcbutilimage, xcbutilkeysyms, xcbutilwm, libxkbcommon
, fontconfig, freetype, harfbuzz
, openssl, dbus, glib, udev, libxml2, libxslt, pcre16
, zlib, libjpeg, libpng, libtiff, sqlite, icu

, coreutils, bison, flex, gdb, gperf, lndir
, patchelf, perl, pkgconfig, python2

# optional dependencies
, cups ? null
, mysql ? null, postgresql ? null

# options
, mesaSupported, mesa
, buildExamples ? false
, buildTests ? false
, developerBuild ? false
, libgnomeui, GConf, gnome_vfs, gtk2
, decryptSslTraffic ? false
}:

let
  inherit (srcs.qt5) version;
  system-x86_64 = lib.elem stdenv.system lib.platforms.x86_64;

  # Search path for Gtk plugin
  gtkLibPath = lib.makeLibraryPath [ gtk2 gnome_vfs libgnomeui GConf ];

  dontInvalidateBacking = fetchpatch {
    url = "https://codereview.qt-project.org/gitweb?p=qt/qtbase.git;a=patch;h=0f68f8920573cdce1729a285a92ac8582df32841;hp=24c50f8dcf7fa61ac3c3d4d6295c259a104a2b8c";
    name = "qtbug-48321-dont-invalidate-backing-store.patch";
    sha256 = "1wynm2hhbhpvzvsz4vpzzkl0ss5skac6934bva8brcpi5xq68h1q";
  };
in

stdenv.mkDerivation {

  name = "qtbase-${version}";
  inherit version;

  srcs = with srcs; [ qt5.src qtbase.src ];

  sourceRoot = "qt-everywhere-opensource-src-${version}";

  outputs = [ "out" "dev" "gtk" ];

  postUnpack = ''
    mv qtbase-opensource-src-${version} ./qt-everywhere-opensource-src-${version}/qtbase
  '';

  patches =
    copyPathsToStore (lib.readPathsFromFile ./. ./series)
    ++ lib.optional decryptSslTraffic ./decrypt-ssl-traffic.patch
    ++ lib.optional mesaSupported [ ./dlopen-gl.patch ./mkspecs-libgl.patch ];

  postPatch =
    ''
      cd qtbase
      patch -p1 <${dontInvalidateBacking}
      cd ..

      substituteInPlace configure --replace /bin/pwd pwd
      substituteInPlace qtbase/configure --replace /bin/pwd pwd
      substituteInPlace qtbase/src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
      sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i qtbase/mkspecs/*/*.conf

      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/src/corelib/Qt5Config.cmake.in"
      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/src/corelib/Qt5CoreMacros.cmake"
      sed -i 's/NO_DEFAULT_PATH//' "qtbase/src/gui/Qt5GuiConfigExtras.cmake.in"
      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/mkspecs/features/data/cmake/Qt5BasicConfig.cmake.in"

      substituteInPlace qtbase/src/network/kernel/qdnslookup_unix.cpp \
        --replace "@glibc@" "${stdenv.cc.libc.out}"
      substituteInPlace qtbase/src/network/kernel/qhostinfo_unix.cpp \
        --replace "@glibc@" "${stdenv.cc.libc.out}"

      substituteInPlace qtbase/src/plugins/platforms/xcb/qxcbcursor.cpp \
        --replace "@libXcursor@" "${libXcursor.out}"

      substituteInPlace qtbase/src/network/ssl/qsslsocket_openssl_symbols.cpp \
        --replace "@openssl@" "${openssl.out}"

      substituteInPlace qtbase/src/dbus/qdbus_symbols.cpp \
        --replace "@dbus_libs@" "${dbus.lib}"

      substituteInPlace \
        qtbase/src/plugins/platforminputcontexts/compose/generator/qtablegenerator.cpp \
        --replace "@libX11@" "${libX11.out}"
    ''
    + lib.optionalString mesaSupported ''
      substituteInPlace \
        qtbase/src/plugins/platforms/xcb/gl_integrations/xcb_glx/qglxintegration.cpp \
        --replace "@mesa_lib@" "${mesa.out}"
      substituteInPlace qtbase/mkspecs/common/linux.conf \
        --replace "@mesa_lib@" "${mesa.out}" \
        --replace "@mesa_inc@" "${mesa.dev}"
    '';


  setOutputFlags = false;
  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/qtbase/lib:$PWD/qtbase/plugins/platforms:$LD_LIBRARY_PATH"
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
    -c++11
    ${lib.optionalString developerBuild "-developer-build"}
    -largefile
    -accessibility
    -rpath
    -optimized-qmake
    -strip
    -no-reduce-relocations
    -system-proxies
    -pkg-config

    -gui
    -widgets
    -opengl desktop
    -qml-debug
    -nis
    -iconv
    -icu
    -pch
    -glib
    -xcb
    -qpa xcb
    -${lib.optionalString (cups == null) "no-"}cups
    -gtkstyle

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

    -system-sqlite
    -${if mysql != null then "plugin" else "no"}-sql-mysql
    -${if postgresql != null then "plugin" else "no"}-sql-psql

    -make libs
    -make tools
    -${lib.optionalString (buildExamples == false) "no"}make examples
    -${lib.optionalString (buildTests == false) "no"}make tests
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
    xlibs.libXcomposite libX11 libxcb libXext libXrender libXi
    xcbutil xcbutilimage xcbutilkeysyms xcbutilwm libxkbcommon
  ]
  ++ lib.optional mesaSupported mesa;

  buildInputs =
    [ bison flex gperf ]
    ++ lib.optional developerBuild gdb
    ++ lib.optional (cups != null) cups
    ++ lib.optional (mysql != null) mysql.lib
    ++ lib.optional (postgresql != null) postgresql
    # FIXME: move to the main list on rebuild.
    ++ [gnome_vfs.out libgnomeui.out gtk2 GConf];

  nativeBuildInputs = [ lndir patchelf perl pkgconfig python2 ];

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

    # Move the QGtkStyle plugin to the gtk output
    mkdir -p "$gtk/lib/qt5/plugins/platformthemes"
    mv "$out/lib/qt5/plugins/platformthemes/libqgtk2.so" "$gtk/lib/qt5/plugins/platformthemes"
    rm "$out/lib/cmake/Qt5Gui/Qt5Gui_QGtk2ThemePlugin.cmake"

    # Set RPATH for QGtkStyle plugin
    qgtk2="$gtk/lib/qt5/plugins/platformthemes/libqgtk2.so"
    qgtk2_RPATH="$(patchelf --print-rpath "$qgtk2")"
    qgtk2_RPATH="$qgtk2_RPATH''${qgtk2_RPATH:+:}${gtkLibPath}"
    patchelf "$qgtk2" \
        --add-needed libgtk-x11-2.0.so \
        --add-needed libgnomeui-2.so \
        --add-needed libgnomevfs-2.so \
        --add-needed libgconf-2.so \
        --set-rpath "$qgtk2_RPATH"
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
    '';

  inherit lndir;
  setupHook = ../../qtbase-setup-hook.sh;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://www.qt.io;
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ bbenoist qknight ttuegel ];
    platforms = platforms.linux;
  };

}
