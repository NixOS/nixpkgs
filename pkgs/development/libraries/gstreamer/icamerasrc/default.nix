{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, gst_all_1
, ipu6-camera-hal
, libdrm
}:

stdenv.mkDerivation rec {
  pname = "icamerasrc-${ipu6-camera-hal.ipuVersion}";
  version = "unstable-2023-03-09";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "icamerasrc";
    rev = "17841ab6249aaa69bd9b3959262bf182dee74111";
    hash = "sha256-j8ZYe4nyy5yfo10CGeXDwbAaAPvdr0ptMWB8hQDyESQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  preConfigure = ''
    # https://github.com/intel/ipu6-camera-hal/issues/1
    export CHROME_SLIM_CAMHAL=ON
    # https://github.com/intel/icamerasrc/issues/22
    export STRIP_VIRTUAL_CHANNEL_CAMHAL=ON
  '';

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    ipu6-camera-hal
    libdrm
  ];

  NIX_CFLAGS_COMPILE = [
    # gstcameradeinterlace.cpp:55:10: fatal error: gst/video/video.h: No such file or directory
    "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0"
  ];

  enableParallelBuilding = true;

  passthru = {
    inherit (ipu6-camera-hal) ipuVersion;
  };

  meta = with lib; {
    description = "GStreamer Plugin for MIPI camera support through the IPU6/IPU6EP/IPU6SE on Intel Tigerlake/Alderlake/Jasperlake platforms";
    homepage = "https://github.com/intel/icamerasrc/tree/icamerasrc_slim_api";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ hexa ];
    platforms = [ "x86_64-linux" ];
  };
}
