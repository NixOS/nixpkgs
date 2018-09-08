{ qtModule, stdenv, lib, fetchurl
, qtbase, qtdeclarative, qtlocation, qtsensors, qtwebchannel
, fontconfig, gdk_pixbuf, gtk2, libwebp, libxml2, libxslt
, sqlite, systemd, glib, gst_all_1, cmake
, bison2, flex, gdb, gperf, perl, pkgconfig, python2, ruby
, darwin
, flashplayerFix ? false
}:

let
  inherit (lib) optional optionals getLib;
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
in
qtModule {
  name = "qtwebkit";
  qtInputs = [ qtbase qtdeclarative qtlocation qtsensors ] ++ optionals (lib.versionAtLeast qtbase.version "5.11.0") [ qtwebchannel ];
  buildInputs = [ fontconfig libwebp libxml2 libxslt sqlite glib gst_all_1.gstreamer gst_all_1.gst-plugins-base ]
    ++ optionals (stdenv.isDarwin) (with darwin.apple_sdk.frameworks; [ OpenGL ])
    ++ optionals (lib.versionAtLeast qtbase.version "5.11.0") [ hyphen ];
  nativeBuildInputs = [
    bison2 flex gdb gperf perl pkgconfig python2 ruby
  ] ++ optionals (lib.versionAtLeast qtbase.version "5.11.0") [ cmake ];

  cmakeFlags = optionals (lib.versionAtLeast qtbase.version "5.11.0") [ "-DPORT=Qt" ];

  __impureHostDeps = optionals (stdenv.isDarwin) [
    "/usr/lib/libicucore.dylib"
  ];

  # QtWebKit overrides qmake's default_pre and default_post features,
  # so its custom qmake files must be found first at the front of QMAKEPATH.
  preConfigure = ''
    QMAKEPATH="$PWD/Tools/qmake''${QMAKEPATH:+:}$QMAKEPATH"
    fixQtBuiltinPaths . '*.pr?'
    # Fix hydra's "Log limit exceeded"
    export qmakeFlags="$qmakeFlags CONFIG+=silent"
  '';

  NIX_CFLAGS_COMPILE =
    # with gcc7 this warning blows the log over Hydra's limit
    [ "-Wno-expansion-to-defined" ]
    # with clang this warning blows the log over Hydra's limit
    ++ optional stdenv.isDarwin "-Wno-inconsistent-missing-override"
    ++ optionals flashplayerFix
      [
        ''-DNIXPKGS_LIBGTK2="${getLib gtk2}/lib/libgtk-x11-2.0"''
        ''-DNIXPKGS_LIBGDK2="${getLib gdk_pixbuf}/lib/libgdk-x11-2.0"''
      ]
    ++ optional (!stdenv.isDarwin) ''-DNIXPKGS_LIBUDEV="${getLib systemd}/lib/libudev"'';

  doCheck = false; # fails 13 out of 13 tests (ctest)

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

  meta.maintainers = with stdenv.lib.maintainers; [ abbradar periklis ];
}
