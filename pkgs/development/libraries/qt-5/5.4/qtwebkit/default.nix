{ qtSubmodule, stdenv, qtdeclarative, qtlocation, qtmultimedia, qtsensors
, fontconfig, gdk_pixbuf, gtk, libwebp, libxml2, libxslt
, sqlite, udev
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
          inherit gtk gdk_pixbuf;
        };
        dlopen-webkit-gtk = substituteAll {
          src = ./0002-dlopen-webkit-gtk.patch;
          inherit gtk;
        };
        dlopen-webkit-udev = substituteAll {
          src = ./0003-dlopen-webkit-udev.patch;
          inherit udev;
        };
    in optionals flashplayerFix [ dlopen-webkit-nsplugin dlopen-webkit-gtk ]
    ++ [ dlopen-webkit-udev ];
}
