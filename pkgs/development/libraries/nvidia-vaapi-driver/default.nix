{ stdenv
, fetchFromGitHub
, lib
, meson
, ninja
, pkg-config
, libGL
, gst_all_1
, nv-codec-headers-11
, libva
, addOpenGLRunpath
}:

stdenv.mkDerivation rec {
  pname = "nvidia-vaapi-driver";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "elFarto";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/9PCqjs0hiIM7ZLvDesff5Bh0a1B8/w/CTw62spw+j4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    addOpenGLRunpath
  ];

  buildInputs = [
    libGL
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    nv-codec-headers-11
    libva
  ];

  postFixup = ''
    addOpenGLRunpath "$out/lib/dri/nvidia_drv_video.so"
  '';

  meta = with lib;{
    homepage = "https://github.com/elFarto/nvidia-vaapi-driver";
    description = "A VA-API implemention using NVIDIA's NVDEC";
    license = licenses.mit;
    maintainers = with maintainers;[ nickcao ];
  };
}
