{ qtSubmodule, qtquickcontrols, qtlocation, qtwebchannel

, xlibs, libXcursor, libXScrnSaver, libXrandr, libXtst
, fontconfig, freetype, harfbuzz, icu, dbus
, zlib, minizip, libjpeg, libpng, libtiff, libwebp, libopus
, jsoncpp, protobuf, libvpx, srtp, snappy, nss, libevent
, alsaLib
, libcap
, pciutils
, systemd

, bison, flex, git, which, gperf
, coreutils
, pkgconfig, python2
, enableProprietaryCodecs ? true

, lib, stdenv # lib.optional, needsPax
}:

with stdenv.lib;

qtSubmodule {
  name = "qtwebengine";
  qtInputs = [ qtquickcontrols qtlocation qtwebchannel ];
  buildInputs = [ bison flex git which gperf ];
  nativeBuildInputs = [ pkgconfig python2 coreutils ];
  doCheck = true;
  outputs = [ "out" "dev" "bin" ];

  enableParallelBuilding = true;

  preConfigure = ''
    export MAKEFLAGS=-j$NIX_BUILD_CORES
    substituteInPlace ./src/3rdparty/chromium/build/common.gypi \
      --replace /bin/echo ${coreutils}/bin/echo
    substituteInPlace ./src/3rdparty/chromium/v8/gypfiles/toolchain.gypi \
      --replace /bin/echo ${coreutils}/bin/echo
    substituteInPlace ./src/3rdparty/chromium/v8/gypfiles/standalone.gypi \
      --replace /bin/echo ${coreutils}/bin/echo

    # Fix library paths
    sed -i \
      -e "s,QLibraryInfo::location(QLibraryInfo::DataPath),QLatin1String(\"$out\"),g" \
      -e "s,QLibraryInfo::location(QLibraryInfo::TranslationsPath),QLatin1String(\"$out/translations\"),g" \
      -e "s,QLibraryInfo::location(QLibraryInfo::LibraryExecutablesPath),QLatin1String(\"$out/libexec\"),g" \
      src/core/web_engine_library_info.cpp
 '' + optionalString (!stdenv.isDarwin) ''
    sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${systemd.lib}/lib/\1!' \
      src/3rdparty/chromium/device/udev_linux/udev?_loader.cc

    sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
      src/3rdparty/chromium/gpu/config/gpu_info_collector_linux.cc
  '';

  qmakeFlags = optional enableProprietaryCodecs "WEBENGINE_CONFIG+=use_proprietary_codecs";

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
  ++ optionals (!stdenv.isDarwin) [
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
  patches = optional stdenv.needsPax ./qtwebengine-paxmark-mksnapshot.patch;
  postInstall = ''
    cat > $out/libexec/qt.conf <<EOF
    [Paths]
    Prefix = ..
    EOF

    paxmark m $out/libexec/QtWebEngineProcess

    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
