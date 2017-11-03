{ qtSubmodule, stdenv, copyPathsToStore, lib
, qtdeclarative, qtlocation, qtsensors
, fontconfig, gdk_pixbuf, gtk2, libwebp, libxml2, libxslt
, sqlite, systemd, glib, gst_all_1
, bison2, flex, gdb, gperf, perl, pkgconfig, python2, ruby
, darwin
, substituteAll
, flashplayerFix ? false
}:

let inherit (lib) optional optionals getLib; in

qtSubmodule {
  name = "qtwebkit";
  qtInputs = [ qtdeclarative qtlocation qtsensors ];
  buildInputs = [ fontconfig libwebp libxml2 libxslt sqlite glib gst_all_1.gstreamer gst_all_1.gst-plugins-base ]
    ++ optionals (stdenv.isDarwin) (with darwin.apple_sdk.frameworks; [ OpenGL ]);
  nativeBuildInputs = [
    bison2 flex gdb gperf perl pkgconfig python2 ruby
  ];

  __impureHostDeps = optionals (stdenv.isDarwin) [
    "/usr/lib/libicucore.dylib"
  ];

  patches =  copyPathsToStore (lib.readPathsFromFile ./. ./series);

  NIX_CFLAGS_COMPILE =
    optionals flashplayerFix
      [
        ''-DNIXPKGS_LIBGTK2="${getLib gtk2}/lib/libgtk-x11-2.0"''
        ''-DNIXPKGS_LIBGDK2="${getLib gdk_pixbuf}/lib/libgdk-x11-2.0"''
      ]
    ++ optional (!stdenv.isDarwin) ''-DNIXPKGS_LIBUDEV="${getLib systemd}/lib/libudev"'';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

  meta.maintainers = with stdenv.lib.maintainers; [ abbradar periklis ];
}
