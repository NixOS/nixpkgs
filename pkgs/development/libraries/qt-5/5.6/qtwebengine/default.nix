{ qtSubmodule, qtquickcontrols, qtlocation, qtwebchannel

, xlibs, libXcursor, libXScrnSaver, libXrandr, libXtst
, fontconfig, freetype, harfbuzz, icu, dbus
, zlib, minizip, libjpeg, libpng, libtiff, libwebp, libopus
, jsoncpp, protobuf, libvpx, srtp, snappy, nss, libevent
, alsaLib
, libcap
, pciutils

, bison, flex, git, which, gperf
, coreutils
, pkgconfig, python2

, lib, stdenv # lib.optional, needsPax
}:

qtSubmodule {
  name = "qtwebengine";
  qtInputs = [ qtquickcontrols qtlocation qtwebchannel ];
  buildInputs = [ bison flex git which gperf ];
  nativeBuildInputs = [ pkgconfig python2 coreutils ];
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

    # fix default SSL bundle location
    sed -i -e 's,/cert.pem,/certs/ca-bundle.crt,' src/3rdparty/chromium/third_party/boringssl/src/crypto/x509/x509_def.c

    configureFlags+="\
        -plugindir $out/$qtPluginPrefix \
        -qmldir $out/$qtQmlPrefix \
        -docdir $out/$qtDocPrefix"
  '';
  propagatedBuildInputs = [
    # Image formats
    libjpeg libpng libtiff libwebp

    # Video formats
    srtp libvpx

    # Audio formats
    libopus

    # Text rendering
    harfbuzz icu
  ]
  ++ lib.optionals (!stdenv.isDarwin) [
    dbus zlib minizip snappy nss protobuf jsoncpp libevent

    # Audio formats
    alsaLib

    # Text rendering
    fontconfig freetype

    libcap
    pciutils

    # X11 libs
    xlibs.xrandr libXScrnSaver libXcursor libXrandr xlibs.libpciaccess libXtst
    xlibs.libXcomposite
  ];
  patches = [
    ./chromium-clang-update-py.patch
  ] ++ stdenv.lib.optional stdenv.needsPax ./qtwebengine-paxmark-mksnapshot.patch;

  postInstall = ''
    cat > $out/libexec/qt.conf <<EOF
    [Paths]
    Prefix = ..
    EOF

    paxmark m $out/libexec/QtWebEngineProcess
  '';
}
