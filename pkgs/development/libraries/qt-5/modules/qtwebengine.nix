{ qtModule, qtCompatVersion,
  qtdeclarative, qtquickcontrols, qtlocation, qtwebchannel

, bison, coreutils, flex, git, gperf, ninja, pkgconfig, python2, which

, xorg, libXcursor, libXScrnSaver, libXrandr, libXtst
, fontconfig, freetype, harfbuzz, icu, dbus, libdrm
, zlib, minizip, libjpeg, libpng, libtiff, libwebp, libopus
, jsoncpp, protobuf, libvpx, srtp, snappy, nss, libevent
, alsaLib
, libcap
, pciutils
, systemd

, enableProprietaryCodecs ? true

, lib, stdenv # lib.optional, needsPax
}:

with stdenv.lib;

let qt56 = qtCompatVersion == "5.6"; in

qtModule {
  name = "qtwebengine";
  qtInputs = [ qtdeclarative qtquickcontrols qtlocation qtwebchannel ];
  nativeBuildInputs = [
    bison coreutils flex git gperf ninja pkgconfig python2 which
  ];
  doCheck = true;
  outputs = [ "bin" "dev" "out" ];

  enableParallelBuilding = true;

  postPatch =
    # Patch Chromium build tools
    ''
      ( cd src/3rdparty/chromium; patchShebangs . )
    ''
    # Patch Chromium build files
    + ''
      substituteInPlace ./src/3rdparty/chromium/build/common.gypi \
        --replace /bin/echo ${coreutils}/bin/echo
      substituteInPlace ./src/3rdparty/chromium/v8/${if qt56 then "build" else "gypfiles"}/toolchain.gypi \
        --replace /bin/echo ${coreutils}/bin/echo
      substituteInPlace ./src/3rdparty/chromium/v8/${if qt56 then "build" else "gypfiles"}/standalone.gypi \
        --replace /bin/echo ${coreutils}/bin/echo
    ''
    # Patch library paths in Qt sources
    + ''
      sed -i \
        -e "s,QLibraryInfo::location(QLibraryInfo::DataPath),QLatin1String(\"$out\"),g" \
        -e "s,QLibraryInfo::location(QLibraryInfo::TranslationsPath),QLatin1String(\"$out/translations\"),g" \
        -e "s,QLibraryInfo::location(QLibraryInfo::LibraryExecutablesPath),QLatin1String(\"$out/libexec\"),g" \
        src/core/web_engine_library_info.cpp
    ''
    # Patch library paths in Chromium sources
    + optionalString (!stdenv.isDarwin) ''
      sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${systemd.lib}/lib/\1!' \
        src/3rdparty/chromium/device/udev_linux/udev?_loader.cc

      sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
        src/3rdparty/chromium/gpu/config/gpu_info_collector_linux.cc
    '';

  preConfigure = ''
    export MAKEFLAGS=-j$NIX_BUILD_CORES

    if [ -d "$PWD/tools/qmake" ]; then
        QMAKEPATH="$PWD/tools/qmake''${QMAKEPATH:+:}$QMAKEPATH"
    fi
 '';

  qmakeFlags =
    [
      # Use system Ninja because bootstrapping it is fragile
      "WEBENGINE_CONFIG+=use_system_ninja"
    ] ++ optional enableProprietaryCodecs "WEBENGINE_CONFIG+=use_proprietary_codecs";

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
    xorg.xrandr libXScrnSaver libXcursor libXrandr xorg.libpciaccess libXtst
    xorg.libXcomposite xorg.libXdamage libdrm
  ];

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  postInstall = ''
    cat > $out/libexec/qt.conf <<EOF
    [Paths]
    Prefix = ..
    EOF

    paxmark m $out/libexec/QtWebEngineProcess
  '';
}
