{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gst_all_1,
  ipu6-camera-hal,
  libdrm,
  libva,
  apple-sdk_gstreamer,
}:

stdenv.mkDerivation {
  pname = "icamerasrc-${ipu6-camera-hal.ipuVersion}";
  version = "unstable-2024-09-29";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "icamerasrc";
    tag = "20240926_1446";
    hash = "sha256-BpIZxkPmSVKqPntwBJjGmCaMSYFCEZHJa4soaMAJRWE=";
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
    gst_all_1.gst-plugins-bad
    ipu6-camera-hal
    libdrm
    libva
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_gstreamer
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
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
