# Maintainer's Notes:
#
# Minor updates:
#  1. Edit ./manifest.sh to point to the updated URL.
#  2. Run ./manifest.sh.
#  3. Build and enjoy.
#
# Major updates:
#  We prefer not to immediately overwrite older versions with major updates, so
#  make a copy of this directory first. After copying, be sure to delete ./tmp
#  if it exists. Then follow the minor update instructions. Be sure to check if
#  any new components have been added and package them as necessary.

{ autonix, fetchurl, newScope, stdenv

, bison2
, mesa_noglu
, libudev
, cups
, gnome

# options
, developerBuild ? false
, decryptSslTraffic ? false
}:

with autonix;
with stdenv.lib;

let
  srcs =
    let
      manifest = builtins.fromJSON (builtins.readFile ./manifest.json);
      mirror = "http://download.qt.io";
      fetch = src: fetchurl (src // { url = "${mirror}/${src.url}"; });
      mkPair = pkg: nameValuePair (builtins.parseDrvName pkg.name).name (fetch pkg.src);
      pairs = map mkPair manifest;
    in listToAttrs pairs;

  version = "5.4.2";

  callPackage = newScope (self // { inherit qtSubmodule; });

  qtSubmodule = callPackage ./qt-submodule.nix {
    inherit srcs version;
    inherit (stdenv) mkDerivation;
  };

  self =
    {

      activeqt = callPackage
        (
          { qtSubmodule, base }:

          qtSubmodule {
            name = "qtactiveqt";
            qtInputs = [ base ];
          }
        )
        {};

      /* androidextras = not packaged */

      base = callPackage ./qtbase.nix {
        mesa = mesa_noglu;
        cups = if stdenv.isLinux then cups else null;
        # GNOME dependencies are not used unless gtkStyle == true
        inherit (gnome) libgnomeui GConf gnome_vfs;
        bison = bison2; # error: too few arguments to function 'int yylex(...
        inherit developerBuild srcs version decryptSslTraffic;
      };

      connectivity = callPackage
        (
          { qtSubmodule, base, declarative }:

          qtSubmodule {
            name = "qtconnectivity";
            qtInputs = [ base declarative ];
          }
        )
        {};

      declarative = callPackage
        (
          { qtSubmodule, python, base, svg, xmlpatterns }:

          qtSubmodule {
            name = "qtdeclarative";
            qtInputs = [ base svg xmlpatterns ];
            nativeBuildInputs = [ python ];
          }
        )
        {};

      doc = callPackage
        (
          { qtSubmodule, declarative }:

          qtSubmodule {
            name = "qtdoc";
            qtInputs = [ declarative ];
          }
        )
        {};

      enginio = callPackage
        (
          { qtSubmodule, declarative }:

          qtSubmodule {
            name = "qtenginio";
            qtInputs = [ declarative ];
          }
        )
        {};

      graphicaleffects = callPackage
        (
          { qtSubmodule, declarative }:

          qtSubmodule {
            name = "qtgraphicaleffects";
            qtInputs = [ declarative ];
          }
        )
        {};

      imageformats = callPackage
        (
          { qtSubmodule, base }:

          qtSubmodule {
            name = "qtimageformats";
            qtInputs = [ base ];
          }
        )
        {};

      location = callPackage
        (
          { qtSubmodule, base, multimedia }:

          qtSubmodule {
            name = "qtlocation";
            qtInputs = [ base multimedia ];
          }
        )
        {};

      /* macextras = not packaged */

      multimedia = callPackage
        (
          { qtSubmodule, base, declarative, pkgconfig
          , alsaLib, gstreamer, gst_plugins_base, libpulseaudio
          }:

          qtSubmodule {
            name = "qtmultimedia";
            qtInputs = [ base declarative ];
            buildInputs = [
              pkgconfig alsaLib gstreamer gst_plugins_base libpulseaudio
            ];
          }
        )
        {};

      quick1 = callPackage
        (
          { qtSubmodule, script, svg, webkit, xmlpatterns }:

          qtSubmodule {
            name = "qtquick1";
            qtInputs = [ script svg webkit xmlpatterns ];
          }
        )
        {};

      quickcontrols = callPackage
        (
          { qtSubmodule, declarative }:

          qtSubmodule {
            name = "qtquickcontrols";
            qtInputs = [ declarative ];
          }
        )
        {};

      script = callPackage
        (
          { qtSubmodule, base, tools }:

          qtSubmodule {
            name = "qtscript";
            qtInputs = [ base tools ];
            patchFlags = "-p2"; # patches originally for monolithic build
            patches = [ ./0003-glib-2.32.patch ];
          }
        )
        {};

      sensors = callPackage
        (
          { qtSubmodule, base, declarative }:

          qtSubmodule {
            name = "qtsensors";
            qtInputs = [ base declarative ];
          }
        )
        {};

      serialport = callPackage
        (
          { qtSubmodule, base, substituteAll }:

          qtSubmodule {
            name = "qtserialport";
            qtInputs = [ base ];
            patchFlags = "-p2"; # patches originally for monolithic build
            patches = [
              (substituteAll {
                src = ./0009-dlopen-serialport-udev.patch;
                libudev = libudev.out;
              })
            ];
          }
        )
        {};

      svg = callPackage
        (
          { qtSubmodule, base }:

          qtSubmodule {
            name = "qtsvg";
            qtInputs = [ base ];
          }
        )
        {};

      tools = callPackage
        (
          { qtSubmodule, activeqt, base, declarative, webkit }:

          qtSubmodule {
            name = "qttools";
            qtInputs = [ activeqt base declarative webkit ];
          }
        )
        {};

      translations = callPackage
        (
          { qtSubmodule, tools }:

          qtSubmodule {
            name = "qttranslations";
            qtInputs = [ tools ];
          }
        )
        {};

      /* wayland = not packaged */

      /* webchannel = not packaged */

      /* webengine = not packaged */

      webkit = callPackage
        (
          { qtSubmodule, declarative, location, multimedia, sensors
          , fontconfig, gdk_pixbuf, gtk, libwebp, libxml2, libxslt
          , sqlite, libudev
          , bison2, flex, gdb, gperf, perl, pkgconfig, python, ruby
          , substituteAll
          , flashplayerFix ? false
          }:

          qtSubmodule {
            name = "qtwebkit";
            qtInputs = [ declarative location multimedia sensors ];
            buildInputs = [ fontconfig libwebp libxml2 libxslt sqlite ];
            nativeBuildInputs = [
              bison2 flex gdb gperf perl pkgconfig python ruby
            ];
            patchFlags = "-p2"; # patches originally for monolithic build
            patches =
              optional flashplayerFix
                (substituteAll
                  {
                    src = ./0002-dlopen-webkit-nsplugin.patch;
                    gtk = gtk.out;
                    gdk_pixbuf = gdk_pixbuf.out;
                  }
                )
              ++ optional flashplayerFix
                (substituteAll
                  {
                    src = ./0007-dlopen-webkit-gtk.patch;
                    gtk = gtk.out;
                  }
                )
              ++ [
                (substituteAll
                  {
                    src = ./0008-dlopen-webkit-udev.patch;
                    libudev = libudev.out;
                  }
                )
              ];
          }
        )
        {};

      webkit-examples = callPackage
        (
          { qtSubmodule, tools, webkit }:

          qtSubmodule {
            name = "qtwebkit-examples";
            qtInputs = [ tools webkit ];
          }
        )
        {};

      websockets = callPackage
        (
          { qtSubmodule, base, declarative }:

          qtSubmodule {
            name = "qtwebsockets";
            qtInputs = [ base declarative ];
          }
        )
        {};

      /* winextras = not packaged */

      x11extras = callPackage
        (
          { qtSubmodule, base }:

          qtSubmodule {
            name = "qtx11extras";
            qtInputs = [ base ];
          }
        )
        {};

      xmlpatterns = callPackage
        (
          { qtSubmodule, base }:

          qtSubmodule {
            name = "qtxmlpatterns";
            qtInputs = [ base ];
          }
        )
        {};

    };

in self
