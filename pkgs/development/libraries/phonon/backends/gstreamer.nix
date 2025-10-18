{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  cmake,
  gst_all_1,
  phonon,
  pkg-config,
  extra-cmake-modules,
  qttools,
  qtbase,
  qtx11extras,
  debug ? false,
}:

stdenv.mkDerivation rec {
  pname = "phonon-backend-gstreamer";
  version = "4.10.0";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "1wk1ip2w7fkh65zk6rilj314dna0hgsv2xhjmpr5w08xa8sii1y5";
  };

  patches = [
    # Hardcode paths to useful plugins so the backend doesn't depend
    # on system paths being set.
    ./gst-plugin-paths.patch

    # Work around https://bugs.kde.org/show_bug.cgi?id=445196 until a new release.
    (fetchpatch {
      url = "https://invent.kde.org/libraries/phonon-gstreamer/-/commit/bbbb160f30a394655cff9398d17961142388b0f2.patch";
      hash = "sha256-tNBqVt67LNb9SQogS9ol8/xYIZvVSoVUgXQahMfkFh8=";
    })
  ];

  dontWrapQtApps = true;

  env.NIX_CFLAGS_COMPILE =
    let
      gstPluginPaths = lib.makeSearchPathOutput "lib" "/lib/gstreamer-1.0" (
        with gst_all_1;
        [
          gstreamer
          gst-plugins-base
          gst-plugins-good
          gst-plugins-ugly
          gst-plugins-bad
          gst-libav
        ]
      );
    in
    toString [
      # This flag should be picked up through pkg-config, but it isn't.
      "-I${gst_all_1.gstreamer.dev}/lib/gstreamer-1.0/include"

      ''-DGST_PLUGIN_PATH_1_0="${gstPluginPaths}"''
    ];

  buildInputs = with gst_all_1; [
    gstreamer
    gst-plugins-base
    phonon
    qtbase
    qtx11extras
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
    qttools
  ];

  cmakeBuildType = if debug then "Debug" else "Release";

  meta = with lib; {
    homepage = "https://phonon.kde.org/";
    description = "GStreamer backend for Phonon";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel ];
    license = licenses.lgpl21;
  };
}
