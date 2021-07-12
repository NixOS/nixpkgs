{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gtk-doc, intltool
, audit, glib, libusb1, libxml2
, wrapGAppsHook
, gstreamer ? null
, gst-plugins-base ? null
, gst-plugins-good ? null
, gst-plugins-bad ? null
, libnotify ? null
, gnome ? null
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
    lib.all
      (pkg: pkg != null && lib.versionAtLeast (lib.getVersion pkg) "1.0")
      [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad ];
in
  assert enableGstPlugin -> lib.all (pkg: pkg != null) [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad ];
  assert enableViewer -> enableGstPlugin;
  assert enableViewer -> libnotify != null;
  assert enableViewer -> gnome != null;
  assert enableViewer -> gtk3 != null;
  assert enableViewer -> gstreamerAtLeastVersion1;

  stdenv.mkDerivation rec {

    pname = "aravis";
    version = "0.6.4";

    src = fetchFromGitHub {
      owner = "AravisProject";
      repo = pname;
      rev= "ARAVIS_${builtins.replaceStrings ["."] ["_"] version}";
      sha256 = "18fnliks661kzc3g8v08hcaj18hjid8b180d6s9gwn0zgv4g374w";
    };

    outputs = [ "bin" "dev" "out" "lib" ];

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
      intltool
      gtk-doc
    ] ++ lib.optional enableViewer wrapGAppsHook;

    buildInputs =
      [ glib libxml2 ]
      ++ lib.optional enableUsb libusb1
      ++ lib.optional enablePacketSocket audit
      ++ lib.optionals (enableViewer || enableGstPlugin) [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad ]
      ++ lib.optionals (enableViewer) [ libnotify gtk3 gnome.adwaita-icon-theme ];

    preAutoreconf = "./autogen.sh";

    configureFlags =
      lib.optional enableUsb "--enable-usb"
        ++ lib.optional enablePacketSocket "--enable-packet-socket"
        ++ lib.optional enableViewer "--enable-viewer"
        ++ lib.optional enableGstPlugin
        (if gstreamerAtLeastVersion1 then "--enable-gst-plugin" else "--enable-gst-0.10-plugin")
        ++ lib.optional enableCppTest "--enable-cpp-test"
        ++ lib.optional enableFastHeartbeat "--enable-fast-heartbeat"
        ++ lib.optional enableAsan "--enable-asan";

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
      license = lib.licenses.lgpl2;
      maintainers = [];
      platforms = lib.platforms.unix;
    };
  }

