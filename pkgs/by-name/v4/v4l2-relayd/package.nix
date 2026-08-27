{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  glib,
  gst_all_1,
  libtool,
  pkg-config,
  which,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "v4l2-relayd";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "vicamo";
    repo = "v4l2-relayd";
    tag = "upstream/${finalAttrs.version}";
    hash = "sha256-kgCVuUvgS7yXEh7DRcZUI0gfuHKwLgUS+FDxR8u//U0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
    which
  ];

  buildInputs = [
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  preConfigure = "./autogen.sh --prefix=$out";

  passthru.updateScript = gitUpdater {
    rev-prefix = "upstream/";
  };

  meta = {
    description = "Streaming relay for v4l2loopback using GStreamer";
    mainProgram = "v4l2-relayd";
    homepage = "https://gitlab.com/vicamo/v4l2-relayd";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ betaboon ];
    platforms = [ "x86_64-linux" ];
  };
})
