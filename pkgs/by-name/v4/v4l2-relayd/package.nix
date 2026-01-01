{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  glib,
  gst_all_1,
  libtool,
  pkg-config,
  which,
<<<<<<< HEAD
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "v4l2-relayd";
  version = "0.1.5";

  src = fetchgit {
    url = "https://git.launchpad.net/v4l2-relayd";
    tag = "upstream/${finalAttrs.version}";
    hash = "sha256-D+OWkny+TYNJt08X+nl7EYs5tp51vjvig/vuID6lkmg=";
  };

=======
}:
stdenv.mkDerivation rec {
  pname = "v4l2-relayd";
  version = "0.1.3";

  src = fetchgit {
    url = "https://git.launchpad.net/v4l2-relayd";
    tag = "upstream/${version}";
    hash = "sha256-oU6naDFZ0PQVHZ3brANfMULDqYMYxeJN+MCUCvN/DpU=";
  };

  patches = [
    ./upstream-v4l2loopback-compatibility.patch
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    rev-prefix = "upstream/";
  };

  meta = {
    description = "Streaming relay for v4l2loopback using GStreamer";
    mainProgram = "v4l2-relayd";
    homepage = "https://git.launchpad.net/v4l2-relayd";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ betaboon ];
    platforms = [ "x86_64-linux" ];
  };
})
=======
  meta = with lib; {
    description = "Streaming relay for v4l2loopback using GStreamer";
    mainProgram = "v4l2-relayd";
    homepage = "https://git.launchpad.net/v4l2-relayd";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ betaboon ];
    platforms = [ "x86_64-linux" ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
