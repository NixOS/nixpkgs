{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gi-docgen
, glib
, libxml2
, gobject-introspection

, enableGstPlugin ? true
, enableViewer ? true
, gst_all_1
, gtk3
, wrapGAppsHook

, enableUsb ? true
, libusb1

, enablePacketSocket ? true
, enableFastHeartbeat ? false
}:

assert enableGstPlugin -> gst_all_1 != null;
assert enableViewer -> enableGstPlugin;
assert enableViewer -> gtk3 != null;
assert enableViewer -> wrapGAppsHook != null;

stdenv.mkDerivation rec {
  pname = "aravis";
  version = "0.8.30";

  src = fetchFromGitHub {
    owner = "AravisProject";
    repo = pname;
    rev = version;
    sha256 = "sha256-1OxvLpzEKxIXiLJIUr+hCx+sxnH9Z5dBM5Lug1acCok=";
  };

  outputs = [ "bin" "dev" "out" "lib" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
  ] ++ lib.optional enableViewer wrapGAppsHook;

  buildInputs =
    [ glib libxml2 ]
    ++ lib.optional enableUsb libusb1
    ++ lib.optionals (enableViewer || enableGstPlugin) (with gst_all_1; [ gstreamer gst-plugins-base (gst-plugins-good.override { gtkSupport = true; }) gst-plugins-bad ])
    ++ lib.optionals (enableViewer) [ gtk3 ];

  mesonFlags = [
  ] ++ lib.optional enableFastHeartbeat "-Dfast-heartbeat=enabled"
  ++ lib.optional (!enableGstPlugin) "-Dgst-plugin=disabled"
  ++ lib.optional (!enableViewer) "-Dviewer=disabled"
  ++ lib.optional (!enableUsb) "-Dviewer=disabled"
  ++ lib.optional (!enablePacketSocket) "-Dpacket-socket=disabled";

  doCheck = true;

  meta = {
    description = "Library for video acquisition using GenICam cameras";
    longDescription = ''
      Implements the gigabit ethernet and USB3 protocols used by industrial cameras.
    '';
    # the documentation is the best working homepage that's not the Github repo
    homepage = "https://aravisproject.github.io/docs/aravis-0.8";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ tpw_rules ];
    platforms = lib.platforms.unix;
  };
}
