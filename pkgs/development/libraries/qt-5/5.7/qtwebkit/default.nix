{ qtSubmodule, stdenv, qtdeclarative, qtlocation, qtsensors
, fontconfig, gdk_pixbuf, gtk, libwebp, libxml2, libxslt
, sqlite, systemd, glib, gst_all_1
, bison2, flex, gdb, gperf, perl, pkgconfig, python, ruby
, substituteAll
, flashplayerFix ? false
}:

with stdenv.lib;

qtSubmodule {
  name = "qtwebkit";
  qtInputs = [ qtdeclarative qtlocation qtsensors ];
  buildInputs = [ fontconfig libwebp libxml2 libxslt sqlite glib gst_all_1.gstreamer gst_all_1.gst-plugins-base ];
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
          libudev = systemd.lib;
        };
    in optionals flashplayerFix [ dlopen-webkit-nsplugin dlopen-webkit-gtk ]
    ++ [ dlopen-webkit-udev ];
  meta.maintainers = with stdenv.lib.maintainers; [ abbradar ];
}
