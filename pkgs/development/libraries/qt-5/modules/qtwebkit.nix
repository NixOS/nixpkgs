{ qtModule, stdenv, lib, fetchurl
, qtbase, qtdeclarative, qtlocation, qtmultimedia, qtsensors, qtwebchannel
, fontconfig, gtk2, libwebp, libxml2, libxslt
, sqlite, systemd, glib, gst_all_1, cmake
, bison, flex, gdb, gperf, perl, pkgconfig, python2, ruby
, darwin
, flashplayerFix ? false
}:

let
  inherit (lib) optional optionals getDev getLib;
  hyphen = stdenv.mkDerivation rec {
    name = "hyphen-2.8.8";
    src = fetchurl {
      url = "http://dev-www.libreoffice.org/src/5ade6ae2a99bc1e9e57031ca88d36dad-${name}.tar.gz";
      sha256 = "304636d4eccd81a14b6914d07b84c79ebb815288c76fe027b9ebff6ff24d5705";
    };
    postPatch = ''
      patchShebangs tests
    '';
    buildInputs = [ perl ];
  };
  usingAnnulenWebkitFork = lib.versionAtLeast qtbase.version "5.11.0";
in
qtModule {
  name = "qtwebkit";
  qtInputs = [ qtbase qtdeclarative qtlocation qtsensors ]
    ++ optional (stdenv.isDarwin && lib.versionAtLeast qtbase.version "5.9.0") qtmultimedia
    ++ optional usingAnnulenWebkitFork qtwebchannel;
  buildInputs = [ fontconfig libwebp libxml2 libxslt sqlite glib gst_all_1.gstreamer gst_all_1.gst-plugins-base ]
    ++ optionals (stdenv.isDarwin) (with darwin; with apple_sdk.frameworks; [ ICU OpenGL ])
    ++ optional usingAnnulenWebkitFork hyphen;
  nativeBuildInputs = [
    bison flex gdb gperf perl pkgconfig python2 ruby
  ] ++ optional usingAnnulenWebkitFork cmake;

  cmakeFlags = optionals usingAnnulenWebkitFork ([ "-DPORT=Qt" ]
    ++ optionals stdenv.isDarwin [
      "-DQt5Multimedia_DIR=${getDev qtmultimedia}/lib/cmake/Qt5Multimedia"
      "-DQt5MultimediaWidgets_DIR=${getDev qtmultimedia}/lib/cmake/Qt5MultimediaWidgets"
      "-DMACOS_FORCE_SYSTEM_XML_LIBRARIES=OFF"
    ]);

  # QtWebKit overrides qmake's default_pre and default_post features,
  # so its custom qmake files must be found first at the front of QMAKEPATH.
  preConfigure = stdenv.lib.optionalString (!usingAnnulenWebkitFork) ''
    QMAKEPATH="$PWD/Tools/qmake''${QMAKEPATH:+:}$QMAKEPATH"
    fixQtBuiltinPaths . '*.pr?'
    # Fix hydra's "Log limit exceeded"
    export qmakeFlags="$qmakeFlags CONFIG+=silent"
  '';

  NIX_CFLAGS_COMPILE = [
      # with gcc7 this warning blows the log over Hydra's limit
      "-Wno-expansion-to-defined"
    ]
    # with gcc8, -Wclass-memaccess became part of -Wall and this too exceeds the logging limit
    ++ optional stdenv.cc.isGNU "-Wno-class-memaccess"
    # with clang this warning blows the log over Hydra's limit
    ++ optional stdenv.isDarwin "-Wno-inconsistent-missing-override"
    ++ optionals flashplayerFix
      [
        ''-DNIXPKGS_LIBGTK2="${getLib gtk2}/lib/libgtk-x11-2.0"''
        # this file used to exist in gdk_pixbuf?
        ''-DNIXPKGS_LIBGDK2="${getLib gtk2}/lib/libgdk-x11-2.0"''
      ]
    ++ optional (!stdenv.isDarwin) ''-DNIXPKGS_LIBUDEV="${getLib systemd}/lib/libudev"'';

  doCheck = false; # fails 13 out of 13 tests (ctest)

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

  meta.maintainers = with stdenv.lib.maintainers; [ abbradar periklis ];
}
