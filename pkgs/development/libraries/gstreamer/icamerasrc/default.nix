{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, gst_all_1
, ipu6-camera-hal
, libdrm
}:

stdenv.mkDerivation {
  pname = "icamerasrc-${ipu6-camera-hal.ipuVersion}";
  version = "unstable-2023-10-23";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "icamerasrc";
    rev = "528a6f177732def4d5ebc17927220d8823bc8fdc";
    hash = "sha256-Ezcm5OpF/NKvJf5sFeJyvNc2Uq0166GukC9MuNUV2Fs=";
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
    "-Wno-error"
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
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
