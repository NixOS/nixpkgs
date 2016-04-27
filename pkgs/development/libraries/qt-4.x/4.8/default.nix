{ stdenv, fetchurl, fetchpatch, substituteAll
, libXrender, libXinerama, libXcursor, libXmu, libXv, libXext
, libXfixes, libXrandr, libSM, freetype, fontconfig, zlib, libjpeg, libpng
, libmng, which, mesaSupported, mesa, mesa_glu, openssl, dbus, cups, pkgconfig
, libtiff, glib, icu, mysql, postgresql, sqlite, perl, coreutils, libXi
, buildMultimedia ? stdenv.isLinux, alsaLib, gstreamer, gst_plugins_base
, buildWebkit ? stdenv.isLinux
, flashplayerFix ? false, gdk_pixbuf
, gtkStyle ? false, libgnomeui, gtk, GConf, gnome_vfs
, developerBuild ? false
, docs ? false
, examples ? false
, demos ? false
, xmlpatterns ? true
}:

with stdenv.lib;

let
  v_maj = "4.8";
  v_min = "7";
  vers = "${v_maj}.${v_min}";
in

# TODO:
#  * move some plugins (e.g., SQL plugins) to dedicated derivations to avoid
#    false build-time dependencies

stdenv.mkDerivation rec {
  name = "qt-${vers}";

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/qt/"
      + "${v_maj}/${vers}/qt-everywhere-opensource-src-${vers}.tar.gz";
    sha256 = "183fca7n7439nlhxyg1z7aky0izgbyll3iwakw4gwivy16aj5272";
  };

  # The version property must be kept because it will be included into the QtSDK package name
  version = vers;

  prePatch = ''
    substituteInPlace configure --replace /bin/pwd pwd
    substituteInPlace src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
    sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i mkspecs/*/*.conf
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # remove impure reference to /usr/lib/libstdc++.6.dylib
    # there might be more references, but this is the only one I could find
    substituteInPlace tools/macdeployqt/tests/tst_deployment_mac.cpp \
      --replace /usr/lib/libstdc++.6.dylib "${stdenv.cc}/lib/libstdc++.6.dylib"
  '';

  patches =
    [ ./glib-2.32.patch
      ./libressl.patch
      (substituteAll {
        src = ./dlopen-absolute-paths.diff;
        cups = if cups != null then cups.out else null;
        icu = icu.out;
        libXfixes = libXfixes.out;
        glibc = stdenv.cc.libc.out;
        openglDriver = if mesaSupported then mesa.driverLink else "/no-such-path";
      })
    ] ++ stdenv.lib.optional gtkStyle (substituteAll {
        src = ./dlopen-gtkstyle.diff;
        # substituteAll ignores env vars starting with capital letter
        gconf = GConf.out;
        gtk = gtk.out;
        libgnomeui = libgnomeui.out;
        gnome_vfs = gnome_vfs.out;
      })
    ++ stdenv.lib.optional flashplayerFix (substituteAll {
        src = ./dlopen-webkit-nsplugin.diff;
        gtk = gtk.out;
        gdk_pixbuf = gdk_pixbuf.out;
      })
    ++ [(fetchpatch {
        name = "fix-medium-font.patch";
        url = "http://anonscm.debian.org/cgit/pkg-kde/qt/qt4-x11.git/plain/debian/patches/"
          + "kubuntu_39_fix_medium_font.diff?id=21b342d71c19e6d68b649947f913410fe6129ea4";
        sha256 = "0bli44chn03c2y70w1n8l7ss4ya0b40jqqav8yxrykayi01yf95j";
      })];

  preConfigure = ''
    export LD_LIBRARY_PATH="`pwd`/lib:$LD_LIBRARY_PATH"
    configureFlags+="
      -docdir $out/share/doc/${name}
      -plugindir $out/lib/qt4/plugins
      -importdir $out/lib/qt4/imports
      -examplesdir $out/share/doc/${name}/examples
      -demosdir $out/share/doc/${name}/demos
      -datadir $out/share/${name}
      -translationdir $out/share/${name}/translations
    "
  '' + optionalString stdenv.cc.isClang ''
    sed -i 's/QMAKE_CC = gcc/QMAKE_CC = clang/' mkspecs/common/g++-base.conf
    sed -i 's/QMAKE_CXX = g++/QMAKE_CXX = clang++/' mkspecs/common/g++-base.conf
  '';

  prefixKey = "-prefix ";
  configureFlags =
    ''
      -v -no-separate-debug-info -release -no-fast -confirm-license -opensource

      -${if stdenv.isFreeBSD then "no-" else ""}opengl -xrender -xrandr -xinerama -xcursor -xinput -xfixes -fontconfig
      -qdbus -${if cups == null then "no-" else ""}cups -glib -dbus-linked -openssl-linked

      ${if mysql != null then "-plugin" else "-no"}-sql-mysql -system-sqlite

      ${if xmlpatterns then "-exceptions -xmlpatterns" else "-no-exceptions"}

      -make libs -make tools -make translations
      -${if demos then "" else "no"}make demos
      -${if examples then "" else "no"}make examples
      -${if docs then "" else "no"}make docs

      -no-phonon ${if buildWebkit then "" else "-no"}-webkit ${if buildMultimedia then "" else "-no"}-multimedia -audio-backend
      ${if developerBuild then "-developer-build" else ""}
    '';

  propagatedBuildInputs =
    [ libXrender libXrandr libXinerama libXcursor libXext libXfixes libXv libXi
      libSM zlib libpng openssl dbus freetype fontconfig glib ]
        # Qt doesn't directly need GLU (just GL), but many apps use, it's small and doesn't remain a runtime-dep if not used
    ++ optional mesaSupported mesa_glu
    ++ optional ((buildWebkit || buildMultimedia) && stdenv.isLinux ) alsaLib
    ++ optionals (buildWebkit || buildMultimedia) [ gstreamer gst_plugins_base ];

  # The following libraries are only used in plugins
  buildInputs =
    [ cups # Qt dlopen's libcups instead of linking to it
      postgresql sqlite libjpeg libmng libtiff icu ]
    ++ optionals (mysql != null) [ mysql.lib ]
    ++ optionals gtkStyle [ gtk gdk_pixbuf ];

  nativeBuildInputs = [ perl pkgconfig which ];

  enableParallelBuilding = false;

  NIX_CFLAGS_COMPILE = optionalString (stdenv.isFreeBSD || stdenv.isDarwin)
    "-I${glib.dev}/include/glib-2.0 -I${glib.out}/lib/glib-2.0/include";

  NIX_LDFLAGS = optionalString (stdenv.isFreeBSD || stdenv.isDarwin)
    "-lglib-2.0";

  preBuild = optionalString stdenv.isDarwin ''
    # resolve "extra qualification on member" error
    sed -i 's/struct ::TabletProximityRec;/struct TabletProximityRec;/' \
      src/gui/kernel/qt_cocoa_helpers_mac_p.h
  '';

  crossAttrs = let
    isMingw = stdenv.cross.libc == "msvcrt";
  in {
    # I've not tried any case other than i686-pc-mingw32.
    # -nomake tools:   it fails linking some asian language symbols
    # -no-svg: it fails to build on mingw64
    configureFlags = ''
      -static -release -confirm-license -opensource
      -no-opengl -no-phonon
      -no-svg
      -make qmake -make libs -nomake tools
      -nomake demos -nomake examples -nomake docs
    '' + optionalString isMingw " -xplatform win32-g++-4.6";
    patches = [];
    preConfigure = ''
      sed -i -e 's/ g++/ ${stdenv.cross.config}-g++/' \
        -e 's/ gcc/ ${stdenv.cross.config}-gcc/' \
        -e 's/ ar/ ${stdenv.cross.config}-ar/' \
        -e 's/ strip/ ${stdenv.cross.config}-strip/' \
        -e 's/ windres/ ${stdenv.cross.config}-windres/' \
        mkspecs/win32-g++/qmake.conf
    '';

    # I don't know why it does not install qmake
    postInstall = ''
      cp bin/qmake* $out/bin
    '';
    dontSetConfigureCross = true;
    dontStrip = true;
  } // optionalAttrs isMingw {
    propagatedBuildInputs = [ ];
  };

  meta = {
    homepage    = http://qt-project.org/;
    description = "A cross-platform application framework for C++";
    license     = licenses.lgpl21Plus; # or gpl3
    maintainers = with maintainers; [ lovek323 phreedom sander urkud ];
    platforms   = platforms.unix;
  };
}
