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
  version = "unstable-2022-12-01";

  src = fetchFromGitHub {
    owner = "elFarto";
    repo = pname;
    rev = "6e8b0d067c52c3a7e0c3de745337e6e733c59207";
    sha256 = "sha256-HL/sjNPsLhzl8NZ/9l8in27vUrMkyUIcNr/+HhiaTT0=";
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
