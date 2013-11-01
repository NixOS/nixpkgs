{ stdenv, fetchurl, substituteAll, libXrender, libXinerama, libXcursor, libXmu, libXv, libXext
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
}:

with stdenv.lib;

let
  v_maj = "4.8";
  v_min = "5";
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
    sha256 = "0f51dbgn1dcck8pqimls2qyf1pfmsmyknh767cvw87c3d218ywpb";
  };

  prePatch = ''
    substituteInPlace configure --replace /bin/pwd pwd
    substituteInPlace src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
    sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i mkspecs/*/*.conf
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # remove impure reference to /usr/lib/libstdc++.6.dylib
    # there might be more references, but this is the only one I could find
    substituteInPlace tools/macdeployqt/tests/tst_deployment_mac.cpp \
      --replace /usr/lib/libstdc++.6.dylib "${stdenv.gcc}/lib/libstdc++.6.dylib"
  '';

  patches =
    [ ./glib-2.32.patch
      (substituteAll {
        src = ./dlopen-absolute-paths.diff;
        inherit cups icu libXfixes;
        glibc = stdenv.gcc.libc;
        openglDriver = if mesaSupported then mesa.driverLink else "/no-such-path";
      })
    ] ++ stdenv.lib.optional gtkStyle (substituteAll {
        src = ./dlopen-gtkstyle.diff;
        # substituteAll ignores env vars starting with capital letter
        gconf = GConf;
        inherit gnome_vfs libgnomeui gtk;
      })
    ++ stdenv.lib.optional flashplayerFix (substituteAll {
        src = ./dlopen-webkit-nsplugin.diff;
        inherit gtk gdk_pixbuf;
      });

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
  '' + optionalString stdenv.isDarwin ''
    export CXX=clang++
    export CC=clang
    sed -i 's/QMAKE_CC = gcc/QMAKE_CC = clang/' mkspecs/common/g++-base.conf
    sed -i 's/QMAKE_CXX = g++/QMAKE_CXX = clang++/' mkspecs/common/g++-base.conf
  '';

  prefixKey = "-prefix ";
  configureFlags =
    ''
      -v -no-separate-debug-info -release -no-fast -confirm-license -opensource

      -opengl -xrender -xrandr -xinerama -xcursor -xinput -xfixes -fontconfig
      -qdbus -${if cups == null then "no-" else ""}cups -glib -dbus-linked -openssl-linked

      ${if mysql != null then "-plugin" else "-no"}-sql-mysql -system-sqlite

      -exceptions -xmlpatterns

      -make libs -make tools -make translations
      -${if demos then "" else "no"}make demos
      -${if examples then "" else "no"}make examples
      -${if docs then "" else "no"}make docs

      -no-phonon ${if buildWebkit then "" else "-no"}-webkit ${if buildMultimedia then "" else "-no"}-multimedia -audio-backend
      ${if developerBuild then "-developer-build" else ""}
    '';

  propagatedBuildInputs =
    [ libXrender libXrandr libXinerama libXcursor libXext libXfixes libXv libXi
      libSM zlib libpng openssl dbus.libs freetype fontconfig glib ]
        # Qt doesn't directly need GLU (just GL), but many apps use, it's small and doesn't remain a runtime-dep if not used
    ++ optional mesaSupported mesa_glu
    ++ optional ((buildWebkit || buildMultimedia) && stdenv.isLinux ) alsaLib
    ++ optionals (buildWebkit || buildMultimedia) [ gstreamer gst_plugins_base ];

  # The following libraries are only used in plugins
  buildInputs =
    [ cups # Qt dlopen's libcups instead of linking to it
      mysql postgresql sqlite libjpeg libmng libtiff icu ]
    ++ optionals gtkStyle [ gtk gdk_pixbuf ];

  nativeBuildInputs = [ perl pkgconfig which ];

  # occasional build problems if one has too many cores (like on Hydra)
  # @vcunat has been unable to find a *reliable* fix
  enableParallelBuilding = false;

  NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin
    "-I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include";

  NIX_LDFLAGS = optionalString stdenv.isDarwin
    "-lglib-2.0";

  preBuild = optionalString stdenv.isDarwin ''
    # resolve "extra qualification on member" error
    sed -i 's/struct ::TabletProximityRec;/struct TabletProximityRec;/' \
      src/gui/kernel/qt_cocoa_helpers_mac_p.h
  '';

  crossAttrs = let
    isMingw = stdenv.cross.config == "i686-pc-mingw32" ||
      stdenv.cross.config == "x86_64-w64-mingw32";
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
    license     = "GPL/LGPL";
    maintainers = with maintainers; [ lovek323 phreedom sander urkud ];
    platforms   = platforms.all;
  };
}
