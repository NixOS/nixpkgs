{ stdenv, fetchurl, substituteAll, libXrender, libXext
, libXfixes, freetype, fontconfig, zlib, libjpeg, libpng
, mesaSupported, mesa, mesa_glu, openssl, dbus, cups, pkgconfig
, libtiff, glib, icu, mysql, postgresql, sqlite, perl, coreutils, libXi
, gdk_pixbuf, python, gdb, xlibs, libX11, libxcb, xcbutil, xcbutilimage
, xcbutilkeysyms, xcbutilwm,udev, libxml2, libxslt, pcre, libxkbcommon
, alsaLib, gstreamer, gst_plugins_base
, pulseaudio, bison, flex, gperf, ruby, libwebp
, flashplayerFix ? false
, gtkStyle ? false, libgnomeui, gtk, GConf, gnome_vfs
, buildDocs ? false
, buildExamples ? false
, buildTests ? false
, developerBuild ? false
}:

with stdenv.lib;

let
  v_maj = "5.2";
  v_min = "1";
  ver = "${v_maj}.${v_min}";
in

stdenv.mkDerivation rec {
  name = "qt-${ver}";

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/qt/"
      + "${v_maj}/${ver}/single/qt-everywhere-opensource-src-${ver}.tar.gz";
    sha256 = "18bxrnyis7xbhpxpf7w42i54hs4qr062b1wx4c0dpmja3lc29sc4";
  };

  # The version property must be kept because it will be included into the QtSDK package name
  version = ver;

  prePatch = ''
    substituteInPlace configure --replace /bin/pwd pwd
    substituteInPlace qtbase/configure --replace /bin/pwd pwd
    substituteInPlace qtbase/src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
    substituteInPlace qtbase/src/plugins/platforminputcontexts/compose/generator/qtablegenerator.cpp \
        --replace /usr/share/X11/locale ${libX11}/share/X11/locale \
        --replace /usr/lib/X11/locale ${libX11}/share/X11/locale
    sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i qtbase/mkspecs/*/*.conf
  '';

  patches =
    [ ./glib-2.32.patch
      (substituteAll {
        src = ./qt-5.2-dlopen-absolute-paths.patch;
        inherit cups icu libXfixes;
        glibc = stdenv.gcc.libc;
        openglDriver = if mesaSupported then mesa.driverLink else "/no-such-path";
      })
    ] ++ optional gtkStyle (substituteAll {
        src = ./dlopen-gtkstyle.patch;
        # substituteAll ignores env vars starting with capital letter
        gconf = GConf;
        inherit gnome_vfs libgnomeui gtk;
      })
    ++ optional flashplayerFix (substituteAll {
        src = ./dlopen-webkit-nsplugin.patch;
        inherit gtk gdk_pixbuf;
      });

  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/qtbase/lib:$PWD/qtbase/plugins/platforms:$PWD/qttools/lib:$LD_LIBRARY_PATH"
    export MAKEFLAGS=-j$NIX_BUILD_CORES
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
    ${optionalString developerBuild "-developer-build"}
    -largefile
    -accessibility
    -rpath
    -optimized-qmake
    -strip
    -reduce-relocations
    -system-proxies

    -gui
    -widgets
    -opengl desktop
    -javascript-jit
    -qml-debug
    -nis
    -iconv
    -icu
    -pch
    -glib
    -xcb
    -qpa xcb
    -${optionalString (cups == null) "no-"}cups

    -no-eglfs
    -no-directfb
    -no-linuxfb
    -no-kms

    -system-zlib
    -system-libpng
    -system-libjpeg
    -system-xcb
    -system-xkbcommon
    -openssl-linked
    -dbus-linked

    -system-sqlite
    -${if mysql != null then "plugin" else "no"}-sql-mysql
    -${if postgresql != null then "plugin" else "no"}-sql-psql

    -make libs
    -make tools
    -${optionalString (buildExamples == false) "no"}make examples
    -${optionalString (buildTests == false) "no"}make tests
  '';

  propagatedBuildInputs = [
    xlibs.libXcomposite libX11 libxcb libXext libXrender libXi
    fontconfig freetype openssl dbus.libs glib udev libxml2 libxslt pcre
    zlib libjpeg libpng libtiff sqlite icu
    libwebp alsaLib gstreamer gst_plugins_base pulseaudio
    xcbutil xcbutilimage xcbutilkeysyms xcbutilwm libxkbcommon
  ]
  # Qt doesn't directly need GLU (just GL), but many apps use, it's small and
  # doesn't remain a runtime-dep if not used
  ++ optionals mesaSupported [ mesa mesa_glu ]
  ++ optional (cups != null) cups
  ++ optional (mysql != null) mysql
  ++ optional (postgresql != null) postgresql;

  buildInputs = [ gdb bison flex gperf ruby ];

  nativeBuildInputs = [ python perl pkgconfig ];

  postInstall =
    ''
      ${optionalString buildDocs ''
        make docs && make install_docs
      ''}

      # Don't retain build-time dependencies like gdb and ruby.
      sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $out/mkspecs/qconfig.pri
    '';

  enableParallelBuilding = true; # often fails on Hydra, as well as qt4

  meta = {
    homepage = http://qt-project.org;
    description = "A cross-platform application framework for C++";
    license = "GPL/LGPL";
    maintainers = [ maintainers.bbenoist ];
    platforms = platforms.linux;
  };
}
