{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  pkg-config,
  libdrm,
  libGL,
  gst_all_1,
  nv-codec-headers-11,
  libva,
  addDriverRunpath,
}:

stdenv.mkDerivation rec {
  pname = "nvidia-vaapi-driver";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "elFarto";
    repo = "nvidia-vaapi-driver";
    rev = "v${version}";
    sha256 = "sha256-Nf2Qh+POkcKXjiHlmpfSCbY+vgT63bWIaMxQHHYtE04=";
  };

  patches = [
    ./0001-hardcode-install_dir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    addDriverRunpath
  ];

  buildInputs = [
    libdrm
    libGL
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    nv-codec-headers-11
    libva
  ];

  postFixup = ''
    addDriverRunpath "$out/lib/dri/nvidia_drv_video.so"
  '';

  meta = with lib; {
    homepage = "https://github.com/elFarto/nvidia-vaapi-driver";
    description = "VA-API implemention using NVIDIA's NVDEC";
    changelog = "https://github.com/elFarto/nvidia-vaapi-driver/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
