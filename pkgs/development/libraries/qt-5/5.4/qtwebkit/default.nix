{ qtSubmodule, stdenv, qtdeclarative, qtlocation, qtmultimedia, qtsensors
, fontconfig, gdk_pixbuf, gtk, libwebp, libxml2, libxslt
, sqlite, libudev
, bison2, flex, gdb, gperf, perl, pkgconfig, python, ruby
, substituteAll
, flashplayerFix ? false
}:

with stdenv.lib;

qtSubmodule {
  name = "qtwebkit";
  qtInputs = [ qtdeclarative qtlocation qtmultimedia qtsensors ];
  buildInputs = [ fontconfig libwebp libxml2 libxslt sqlite ];
  nativeBuildInputs = [
    bison2 flex gdb gperf perl pkgconfig python ruby
  ];
  patches =
    let dlopen-webkit-nsplugin = substituteAll {
          src = ./0001-dlopen-webkit-nsplugin.patch;
          gtk = gtk.out;
          gdk_pixbuf = gdk_pixbuf.out;
        };
        dlopen-webkit-gtk = substituteAll {
          src = ./0002-dlopen-webkit-gtk.patch;
          gtk = gtk.out;
        };
        dlopen-webkit-udev = substituteAll {
          src = ./0003-dlopen-webkit-udev.patch;
          udev = libudev.out;
        };
    in optionals flashplayerFix [ dlopen-webkit-nsplugin dlopen-webkit-gtk ]
    ++ [ dlopen-webkit-udev ];
  postFixup = ''
    fixQtModuleCMakeConfig "WebKit"
    fixQtModuleCMakeConfig "WebKitWidgets"
  '';
}
