{ stdenv, fetchurl, substituteAll, libXrender, libXext
, libXfixes, freetype, fontconfig, zlib, libjpeg, libpng
, mesaSupported, mesa, mesa_glu, openssl, dbus, cups, pkgconfig
, libtiff, glib, icu, mysql, postgresql, sqlite, perl, coreutils, libXi
, gdk_pixbuf, python, gdb, xlibs, libX11, libxcb, xcbutil, xcbutilimage
, xcbutilkeysyms, xcbutilwm, udev, libxml2, libxslt, pcre, libxkbcommon
, alsaLib, gstreamer, gst_plugins_base
, libpulseaudio, bison, flex, gperf, ruby, libwebp, libXcursor
, flashplayerFix ? false
, gtkStyle ? false, libgnomeui, gtk, GConf, gnome_vfs
, buildDocs ? false
, buildExamples ? false
, buildTests ? false
, developerBuild ? false
}:

with stdenv.lib;

let
  v_maj = "5.3";
  v_min = "2";
  ver = "${v_maj}.${v_min}";
in

let system-x86_64 = elem stdenv.system platforms.x86_64; in

stdenv.mkDerivation rec {
  name = "qt-${ver}";

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/qt/"
      + "${v_maj}/${ver}/single/qt-everywhere-opensource-src-${ver}.tar.gz";
    sha256 = "0b98n2jl62dyqxwn1gdj9xmk8wrrdxnazr65fdk5qw1hmlpgvly8";
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
    optional gtkStyle
      (substituteAll {
        src = ./0001-dlopen-gtkstyle.patch;
        # substituteAll ignores env vars starting with capital letter
        gconf = GConf;
        inherit gnome_vfs libgnomeui gtk;
      })
    ++ optional flashplayerFix
      (substituteAll {
        src = ./0002-dlopen-webkit-nsplugin.patch;
        inherit gtk gdk_pixbuf;
      })
    ++ optional flashplayerFix
      (substituteAll {
        src = ./0007-dlopen-webkit-gtk.patch;
        inherit gtk;
      })
    ++ [
      ./0003-glib-2.32.patch
      (substituteAll {
        src = ./0004-dlopen-resolv.patch;
        glibc = stdenv.cc.libc;
      })
      (substituteAll {
        src = ./0005-dlopen-gl.patch;
        openglDriver = if mesaSupported then mesa.driverLink else "/no-such-path";
      })
      ./0006-tzdir.patch
      (substituteAll { src = ./0008-dlopen-webkit-udev.patch; inherit udev; })
      (substituteAll { src = ./0009-dlopen-serialport-udev.patch; inherit udev; })
      (substituteAll { src = ./0010-dlopen-libXcursor.patch; inherit libXcursor; })
      (substituteAll { src = ./0011-dlopen-openssl.patch; inherit openssl; })
      (substituteAll { src = ./0012-dlopen-dbus.patch; dbus_libs = dbus; })
      ./0013-qtwebkit-glib-2.44.patch
    ];

  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/qtbase/lib:$PWD/qtbase/plugins/platforms:$PWD/qttools/lib:$LD_LIBRARY_PATH"
    export MAKEFLAGS=-j$NIX_BUILD_CORES
    export configureFlags+="-plugindir $out/lib/qt5/plugins -importdir $out/lib/qt5/imports -qmldir $out/lib/qt5/qml"
    export configureFlags+=" -docdir $out/share/doc/qt5"
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
    -qml-debug
    -nis
    -iconv
    -icu
    -pch
    -glib
    -xcb
    -qpa xcb
    -${optionalString (cups == null) "no-"}cups
    -${optionalString (!gtkStyle) "no-"}gtkstyle

    -no-eglfs
    -no-directfb
    -no-linuxfb
    -no-kms

    ${optionalString (!system-x86_64) "-no-sse2"}
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

  # PostgreSQL autodetection fails sporadically because Qt omits the "-lpq" flag
  # if dependency paths contain the string "pq", which can occur in the hash.
  # To prevent these failures, we need to override PostgreSQL detection.
  PSQL_LIBS = optionalString (postgresql != null) "-L${postgresql}/lib -lpq";

  propagatedBuildInputs = [
    xlibs.libXcomposite libX11 libxcb libXext libXrender libXi
    fontconfig freetype openssl dbus.libs glib udev libxml2 libxslt pcre
    zlib libjpeg libpng libtiff sqlite icu
    libwebp alsaLib gstreamer gst_plugins_base libpulseaudio
    xcbutil xcbutilimage xcbutilkeysyms xcbutilwm libxkbcommon
  ]
  # Qt doesn't directly need GLU (just GL), but many apps use, it's small and
  # doesn't remain a runtime-dep if not used
  ++ optionals mesaSupported [ mesa mesa_glu ]
  ++ optional (cups != null) cups
  ++ optional (mysql != null) mysql.lib
  ++ optional (postgresql != null) postgresql
  ++ optionals gtkStyle [gnome_vfs libgnomeui gtk GConf];

  buildInputs =
    [ bison flex gperf ruby ]
    ++ optional developerBuild gdb;

  nativeBuildInputs = [ python perl pkgconfig ];

  # freetype-2.5.4 changed signedness of some struct fields
  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare";

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
    maintainers = with maintainers; [ bbenoist qknight ttuegel ];
    platforms = platforms.linux;
  };
}
