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
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "elFarto";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KeOg9VvPTqIo0qB+dcU915yTztvFxo1jJcHHpsmMmfk=";
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
