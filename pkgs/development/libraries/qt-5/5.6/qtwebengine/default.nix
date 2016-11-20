{ qtSubmodule, qtquickcontrols, qtlocation, qtwebchannel

, xlibs, libXcursor, libXScrnSaver, libXrandr, libXtst
, fontconfig, freetype, harfbuzz, icu, dbus
, zlib, libjpeg, libpng, libtiff
, alsaLib
, libcap
, pciutils

, bison, flex, git, which, gperf
, coreutils
, pkgconfig, python

}:

qtSubmodule {
  name = "qtwebengine";
  qtInputs = [ qtquickcontrols qtlocation qtwebchannel ];
  buildInputs = [ bison flex git which gperf ];
  nativeBuildInputs = [ pkgconfig python coreutils ];
  doCheck = true;

  enableParallelBuilding = true;

  preConfigure = ''
    export MAKEFLAGS=-j$NIX_BUILD_CORES
    substituteInPlace ./src/3rdparty/chromium/build/common.gypi \
      --replace /bin/echo ${coreutils}/bin/echo
    substituteInPlace ./src/3rdparty/chromium/v8/build/toolchain.gypi \
      --replace /bin/echo ${coreutils}/bin/echo
    substituteInPlace ./src/3rdparty/chromium/v8/build/standalone.gypi \
      --replace /bin/echo ${coreutils}/bin/echo

    # hardcode paths for which default path resolution does not work in nix
    sed -i -e 's,\(static QString potentialResourcesPath =\).*,\1 QLatin1String("'$out'/resources");,' src/core/web_engine_library_info.cpp
    sed -i -e 's,\(static QString processPath\),\1 = QLatin1String("'$out'/libexec/QtWebEngineProcess"),' src/core/web_engine_library_info.cpp
    sed -i -e 's,\(static QString potentialLocalesPath =\).*,\1 QLatin1String("'$out'/translations/qtwebengine_locales");,' src/core/web_engine_library_info.cpp

    configureFlags+="\
        -plugindir $out/lib/qt5/plugins \
        -importdir $out/lib/qt5/imports \
        -qmldir $out/lib/qt5/qml \
        -docdir $out/share/doc/qt5"
  '';
  propagatedBuildInputs = [
    dbus zlib alsaLib

    # Image formats
    libjpeg libpng libtiff

    # Text rendering
    fontconfig freetype harfbuzz icu

    # X11 libs
    xlibs.xrandr libXScrnSaver libXcursor libXrandr xlibs.libpciaccess libXtst
    xlibs.libXcomposite

    libcap
    pciutils
  ];
  patches = [
    ./chromium-clang-update-py.patch
  ];
  postInstall = ''
    cat > $out/libexec/qt.conf <<EOF
    [Paths]
    Prefix = ..
    EOF
  '';
}
