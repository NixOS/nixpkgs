{ stdenv, fetchurl
, qtSubmodule, qtdeclarative, qtlocation, qtmultimedia, qtsensors
, fontconfig, gdk_pixbuf, gtk, libwebp, libxml2, libxslt
, sqlite, libudev
, bison2, flex, gdb, gperf, perl, pkgconfig, python, ruby
, substituteAll
, flashplayerFix ? false
}:

with stdenv.lib;

qtSubmodule {
  name = "qtwebkit";
  version = "5.6.1-1";
  src = fetchurl {
    url = "http://download.qt.io/community_releases/5.6/5.6.1/.5.6.1-1/qtwebkit-opensource-src-5.6.1.tar.xz";
    sha256 = "f7f2a6c4b371981e6f11b15c8753a6001a79c05a2a6e6c03bbfaf6e4cf6835e6";
  };
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
          libudev = libudev.out;
        };
    in optionals flashplayerFix [ dlopen-webkit-nsplugin dlopen-webkit-gtk ]
    ++ [ dlopen-webkit-udev ];
}
