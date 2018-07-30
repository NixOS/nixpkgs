{ stdenv, lib, fetchurl, fetchpatch, substituteAll
, libXrender, libXinerama, libXcursor, libXv, libXext
, libXfixes, libXrandr, libSM, freetype, fontconfig, zlib, libjpeg, libpng
, libmng, which, libGLSupported, libGLU, openssl, dbus, cups, pkgconfig
, libtiff, glib, icu, mysql, postgresql, sqlite, perl, coreutils, libXi
, buildMultimedia ? stdenv.isLinux, alsaLib, gstreamer, gst-plugins-base
, buildWebkit ? (stdenv.isLinux || stdenv.isDarwin)
, flashplayerFix ? false, gdk_pixbuf
, gtkStyle ? true, gtk2
, gnomeStyle ? false, libgnomeui, GConf, gnome_vfs
, developerBuild ? false
, docs ? false
, examples ? false
, demos ? false
# darwin support
, cf-private, libobjc, ApplicationServices, OpenGL, Cocoa, AGL, libcxx
}:

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

  outputs = [ "out" "dev" ];

  outputInclude = "out";

  setOutputFlags = false;

  # The version property must be kept because it will be included into the QtSDK package name
  version = vers;

  prePatch = ''
    substituteInPlace configure --replace /bin/pwd pwd
    substituteInPlace src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
    sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i mkspecs/*/*.conf
  '' + lib.optionalString stdenv.isDarwin ''
    # remove impure reference to /usr/lib/libstdc++.6.dylib
    # there might be more references, but this is the only one I could find
    substituteInPlace tools/macdeployqt/tests/tst_deployment_mac.cpp \
      --replace /usr/lib/libstdc++.6.dylib "${stdenv.cc}/lib/libstdc++.6.dylib"
  '' + lib.optionalString stdenv.cc.isClang ''
    substituteInPlace src/3rdparty/webkit/Source/WebCore/html/HTMLImageElement.cpp \
      --replace 'optionalHeight > 0' 'optionalHeight != NULL'

    substituteInPlace ./tools/linguist/linguist/messagemodel.cpp \
      --replace 'm->comment()) >= 0' 'm->comment()) != NULL'
  '';

  patches =
    lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
      ./glib-2.32.patch
      ./libressl.patch
      ./parallel-configure.patch
      ./clang-5-darwin.patch
      ./qt-4.8.7-unixmake-darwin.patch
      (substituteAll {
        src = ./dlopen-absolute-paths.diff;
        cups = if cups != null then lib.getLib cups else null;
        icu = icu.out;
        libXfixes = libXfixes.out;
        glibc = stdenv.cc.libc.out;
      })
      (fetchpatch {
        name = "fix-medium-font.patch";
        url = "https://salsa.debian.org/qt-kde-team/qt/qt4-x11/raw/"
          + "21b342d71c19e6d68b649947f913410fe6129ea4/debian/patches/kubuntu_39_fix_medium_font.diff";
        sha256 = "0bli44chn03c2y70w1n8l7ss4ya0b40jqqav8yxrykayi01yf95j";
      })
      (fetchpatch {
        name = "qt4-gcc6.patch";
        url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/qt4-gcc6.patch?h=packages/qt4&id=ca773a144f5abb244ac4f2749eeee9333cac001f";
        sha256 = "07lrva7bjh6i40p7b3ml26a2jlznri8bh7y7iyx5zmvb1gfxmj34";
      })
    ]
    ++ lib.optional gtkStyle (substituteAll ({
        src = ./dlopen-gtkstyle.diff;
        # substituteAll ignores env vars starting with capital letter
        gtk = gtk2.out;
      } // lib.optionalAttrs gnomeStyle {
        gconf = GConf.out;
        libgnomeui = libgnomeui.out;
        gnome_vfs = gnome_vfs.out;
      }))
    ++ lib.optional flashplayerFix (substituteAll {
        src = ./dlopen-webkit-nsplugin.diff;
        gtk = gtk2.out;
        gdk_pixbuf = gdk_pixbuf.out;
      })
    ++ lib.optional stdenv.isAarch64 (fetchpatch {
        url = "https://src.fedoraproject.org/rpms/qt/raw/ecf530486e0fb7fe31bad26805cde61115562b2b/f/qt-aarch64.patch";
        sha256 = "1fbjh78nmafqmj7yk67qwjbhl3f6ylkp6x33b1dqxfw9gld8b3gl";
      })
    ++ lib.optionals stdenv.hostPlatform.isMusl [
        ./qt-musl.patch
        ./qt-musl-iconv-no-bom.patch
        ./patch-qthread-stacksize.diff
        ./qsettings-recursive-global-mutex.patch
      ];

  preConfigure = ''
    export LD_LIBRARY_PATH="`pwd`/lib:$LD_LIBRARY_PATH"
    configureFlags+="
      -docdir $out/share/doc/${name}
      -plugindir $out/lib/qt4/plugins
      -importdir $out/lib/qt4/imports
      -examplesdir $TMPDIR/share/doc/${name}/examples
      -demosdir $TMPDIR/share/doc/${name}/demos
      -datadir $out/share/${name}
      -translationdir $out/share/${name}/translations
      --jobs=$NIX_BUILD_CORES
    "
    unset LD # Makefile uses gcc for linking; setting LD interferes
  '' + lib.optionalString stdenv.cc.isClang ''
    sed -i 's/QMAKE_CC = gcc/QMAKE_CC = clang/' mkspecs/common/g++-base.conf
    sed -i 's/QMAKE_CXX = g++/QMAKE_CXX = clang++/' mkspecs/common/g++-base.conf
  '' + lib.optionalString stdenv.hostPlatform.isWindows ''
    sed -i -e 's/ g++/ ${stdenv.cc.targetPrefix}g++/' \
      -e 's/ gcc/ ${stdenv.cc.targetPrefix}gcc/' \
      -e 's/ ar/ ${stdenv.cc.targetPrefix}ar/' \
      -e 's/ strip/ ${stdenv.cc.targetPrefix}strip/' \
      -e 's/ windres/ ${stdenv.cc.targetPrefix}windres/' \
      mkspecs/win32-g++/qmake.conf
  '';

  prefixKey = "-prefix ";

  ${if stdenv.hostPlatform == stdenv.buildPlatform then null else "configurePlatforms"} = [];
  configureFlags = let
    platformFlag =
      if stdenv.hostPlatform != stdenv.buildPlatform
      then "-xplatform"
      else "-platform";
    in (if stdenv.hostPlatform == stdenv.buildPlatform then ''
      -v -no-separate-debug-info -release -fast -confirm-license -opensource

      -${if stdenv.isFreeBSD then "no-" else ""}opengl -xrender -xrandr -xinerama -xcursor -xinput -xfixes -fontconfig
      -qdbus -${if cups == null then "no-" else ""}cups -glib -dbus-linked -openssl-linked

      ${if mysql != null then "-plugin" else "-no"}-sql-mysql -system-sqlite

      -exceptions -xmlpatterns

      -make libs -make tools -make translations
      -${if demos then "" else "no"}make demos
      -${if examples then "" else "no"}make examples
      -${if docs then "" else "no"}make docs

      -no-phonon ${if buildWebkit then "" else "-no"}-webkit ${if buildMultimedia then "" else "-no"}-multimedia -audio-backend
      ${if developerBuild then "-developer-build" else ""}
    '' else ''
      -static -release -confirm-license -opensource
      -no-opengl -no-phonon
      -no-svg
      -make qmake -make libs -nomake tools
      -nomake demos -nomake examples -nomake docs
    '') + lib.optionalString stdenv.hostPlatform.isDarwin "${platformFlag} unsupported/macx-clang-libc++"
        + lib.optionalString stdenv.hostPlatform.isMinGW  "${platformFlag} win32-g++-4.6";

  propagatedBuildInputs =
    [ libXrender libXrandr libXinerama libXcursor libXext libXfixes libXv libXi
      libSM zlib libpng openssl dbus freetype fontconfig glib ]
        # Qt doesn't directly need GLU (just GL), but many apps use, it's small and doesn't remain a runtime-dep if not used
    ++ lib.optional libGLSupported libGLU
    ++ lib.optional ((buildWebkit || buildMultimedia) && stdenv.isLinux ) alsaLib
    ++ lib.optionals (buildWebkit || buildMultimedia) [ gstreamer gst-plugins-base ];

  # The following libraries are only used in plugins
  buildInputs =
    [ cups # Qt dlopen's libcups instead of linking to it
      postgresql sqlite libjpeg libmng libtiff icu ]
    ++ lib.optionals (mysql != null) [ mysql.connector-c ]
    ++ lib.optionals gtkStyle [ gtk2 gdk_pixbuf ]
    ++ lib.optionals stdenv.isDarwin [ cf-private ApplicationServices OpenGL Cocoa AGL libcxx libobjc ];

  nativeBuildInputs = [ perl pkgconfig which ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE =
    # with gcc7 the warnings blow the log over Hydra's limit
    [ "-Wno-expansion-to-defined" "-Wno-unused-local-typedefs" ]
    ++ lib.optional stdenv.isLinux "-std=gnu++98" # gnu++ in (Obj)C flags is no good on Darwin
    ++ lib.optionals (stdenv.isFreeBSD || stdenv.isDarwin)
      [ "-I${glib.dev}/include/glib-2.0" "-I${glib.out}/lib/glib-2.0/include" ]
    ++ lib.optional stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  NIX_LDFLAGS = lib.optionalString (stdenv.isFreeBSD || stdenv.isDarwin) "-lglib-2.0";

  preBuild = lib.optionalString stdenv.isDarwin ''
    # resolve "extra qualification on member" error
    sed -i 's/struct ::TabletProximityRec;/struct TabletProximityRec;/' \
      src/gui/kernel/qt_cocoa_helpers_mac_p.h
    find . -name "Makefile*" | xargs sed -i 's/^\(LINK[[:space:]]* = clang++\)/\1 ${NIX_LDFLAGS}/'
    sed -i 's/^\(LIBS[[:space:]]*=.*$\)/\1 -lobjc/' ./src/corelib/Makefile.Release
  '';

  doCheck = false; # qwebframe test fails with fontconfig errors

  postInstall = ''
    rm -rf $out/tests
  ''
  # I don't know why it does not install qmake
  + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    cp bin/qmake* $out/bin
  '';

  dontStrip = if stdenv.hostPlatform == stdenv.buildPlatform then null else true;

  meta = {
    homepage    = http://qt-project.org/;
    description = "A cross-platform application framework for C++";
    license     = lib.licenses.lgpl21Plus; # or gpl3
    maintainers = with lib.maintainers; [ orivej lovek323 phreedom sander ];
    platforms   = lib.platforms.unix;
  };
}
