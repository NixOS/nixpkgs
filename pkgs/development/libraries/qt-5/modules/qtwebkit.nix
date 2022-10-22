{ qtModule, stdenv, lib, fetchurl
, qtbase, qtdeclarative, qtlocation, qtmultimedia, qtsensors, qtwebchannel
, fontconfig, libwebp, libxml2, libxslt
, sqlite, systemd, glib, gst_all_1, cmake
, bison, flex, gdb, gperf, perl, pkg-config, python38, ruby
, ICU, OpenGL
}:

let
  hyphen = stdenv.mkDerivation rec {
    pname = "hyphen";
    version = "2.8.8";
    src = fetchurl {
      url = "http://dev-www.libreoffice.org/src/5ade6ae2a99bc1e9e57031ca88d36dad-hyphen-${version}.tar.gz";
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
  pname = "qtwebkit";
  qtInputs = [ qtbase qtdeclarative qtlocation qtsensors ]
    ++ lib.optional (stdenv.isDarwin && lib.versionAtLeast qtbase.version "5.9.0") qtmultimedia
    ++ lib.optional usingAnnulenWebkitFork qtwebchannel;
  buildInputs = [ fontconfig libwebp libxml2 libxslt sqlite glib gst_all_1.gstreamer gst_all_1.gst-plugins-base ]
    ++ lib.optionals stdenv.isDarwin [ ICU OpenGL ]
    ++ lib.optional usingAnnulenWebkitFork hyphen;
  nativeBuildInputs = [
    bison flex gdb gperf perl pkg-config python38 ruby
  ] ++ lib.optional usingAnnulenWebkitFork cmake;

  cmakeFlags = lib.optionals usingAnnulenWebkitFork ([ "-DPORT=Qt" ]
    ++ lib.optionals stdenv.isDarwin [
      "-DQt5Multimedia_DIR=${lib.getDev qtmultimedia}/lib/cmake/Qt5Multimedia"
      "-DQt5MultimediaWidgets_DIR=${lib.getDev qtmultimedia}/lib/cmake/Qt5MultimediaWidgets"
      "-DMACOS_FORCE_SYSTEM_XML_LIBRARIES=OFF"
    ]);

  # QtWebKit overrides qmake's default_pre and default_post features,
  # so its custom qmake files must be found first at the front of QMAKEPATH.
  preConfigure = lib.optionalString (!usingAnnulenWebkitFork) ''
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
  ++ lib.optional stdenv.cc.isGNU "-Wno-class-memaccess"
  # with clang this warning blows the log over Hydra's limit
  ++ lib.optional stdenv.isDarwin "-Wno-inconsistent-missing-override"
  ++ lib.optional (!stdenv.isDarwin) ''-DNIXPKGS_LIBUDEV="${lib.getLib systemd}/lib/libudev"'';

  doCheck = false; # fails 13 out of 13 tests (ctest)

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''
    rm -rf "$(pwd)"
    mkdir "$(pwd)"
  '';

  meta = {
    maintainers = with lib.maintainers; [ abbradar periklis ];
  };
}
