{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk-doc, intltool
, audit, glib, libusb, libxml2
, wrapGAppsHook
, gstreamer ? null
, gst-plugins-base ? null
, gst-plugins-good ? null
, gst-plugins-bad ? null
, libnotify ? null
, gnome3 ? null
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
  assert enableViewer -> gstreamerAtLeastVersion1;

  stdenv.mkDerivation rec {

    pname = "aravis";
    version = "0.5.13";
    name = "${pname}-${version}";

    src = fetchFromGitHub {
      owner = "AravisProject";
      repo = "aravis";
      rev= "c56e530b8ef53b84e17618ea2f334d2cbae04f48";
      sha256 = "1dj24dir239zmiscfhyy1m8z5rcbw0m1vx9lipx0r7c39bzzj5gy";
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
      ++ stdenv.lib.optionals (enableViewer) [ libnotify gnome3.gtk3 gnome3.defaultIconTheme ];

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
      homepage = https://aravisproject.github.io/docs/aravis-0.5;
      license = stdenv.lib.licenses.lgpl2;
      maintainers = [];
      platforms = stdenv.lib.platforms.unix;
    };
  }

