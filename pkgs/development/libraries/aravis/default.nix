{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk-doc, intltool
, audit, glib, libusb, libxml2
, wrapGAppsHook
, gstreamer ? null
, gst-plugins-base ? null
, gst-plugins-good ? null
, gst-plugins-bad ? null
, libnotify ? null
, gnome3 ? null
, gtk3 ? null
, enableUsb ? true
, enablePacketSocket ? true
, enableViewer ? true
, enableGstPlugin ? true
, enableCppTest ? false
, enableFastHeartbeat ? false
, enableAsan ? false
}:

let
  gstreamerAtLeastVersion1 =
    stdenv.lib.all
      (pkg: pkg != null && stdenv.lib.versionAtLeast (stdenv.lib.getVersion pkg) "1.0")
      [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad ];
in
  assert enableGstPlugin -> stdenv.lib.all (pkg: pkg != null) [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad ];
  assert enableViewer -> enableGstPlugin;
  assert enableViewer -> libnotify != null;
  assert enableViewer -> gnome3 != null;
  assert enableViewer -> gtk3 != null;
  assert enableViewer -> gstreamerAtLeastVersion1;

  stdenv.mkDerivation rec {

    pname = "aravis";
    version = "0.6.2";

    src = fetchFromGitHub {
      owner = "AravisProject";
      repo = pname;
      rev= "ARAVIS_${builtins.replaceStrings ["."] ["_"] version}";
      sha256 = "0zlmw040iv0xx9qw7ygzbl96bli6ivll2fbziv19f4bdc0yhqjpw";
    };

    outputs = [ "bin" "dev" "out" "lib" ];

    nativeBuildInputs = [
      autoreconfHook
      pkgconfig
      intltool
      gtk-doc
    ] ++ stdenv.lib.optional enableViewer wrapGAppsHook;

    buildInputs =
      [ glib libxml2 ]
      ++ stdenv.lib.optional enableUsb libusb
      ++ stdenv.lib.optional enablePacketSocket audit
      ++ stdenv.lib.optionals (enableViewer || enableGstPlugin) [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad ]
      ++ stdenv.lib.optionals (enableViewer) [ libnotify gtk3 gnome3.adwaita-icon-theme ];

    preAutoreconf = ''./autogen.sh'';

    configureFlags =
      stdenv.lib.optional enableUsb "--enable-usb"
        ++ stdenv.lib.optional enablePacketSocket "--enable-packet-socket"
        ++ stdenv.lib.optional enableViewer "--enable-viewer"
        ++ stdenv.lib.optional enableGstPlugin
        (if gstreamerAtLeastVersion1 then "--enable-gst-plugin" else "--enable-gst-0.10-plugin")
        ++ stdenv.lib.optional enableCppTest "--enable-cpp-test"
        ++ stdenv.lib.optional enableFastHeartbeat "--enable-fast-heartbeat"
        ++ stdenv.lib.optional enableAsan "--enable-asan";

    postPatch = ''
        ln -s ${gtk-doc}/share/gtk-doc/data/gtk-doc.make .
      '';

    doCheck = true;

    meta = {
      description = "Library for video acquisition using GenICam cameras";
      longDescription = ''
        Implements the gigabit ethernet and USB3 protocols used by industrial cameras.
      '';
      homepage = "https://aravisproject.github.io/docs/aravis-0.5";
      license = stdenv.lib.licenses.lgpl2;
      maintainers = [];
      platforms = stdenv.lib.platforms.unix;
    };
  }

