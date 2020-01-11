{ stdenv, lib, fetchurl, cmake, gst_all_1, phonon, pkgconfig
, extra-cmake-modules, qttools, qtbase, qtx11extras
, debug ? false
}:

with lib;

stdenv.mkDerivation rec {
  pname = "phonon-backend-gstreamer";
  version = "4.10.0";

  meta = with stdenv.lib; {
    homepage = https://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel ];
    license = licenses.lgpl21;
  };

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "1wk1ip2w7fkh65zk6rilj314dna0hgsv2xhjmpr5w08xa8sii1y5";
  };

  # Hardcode paths to useful plugins so the backend doesn't depend
  # on system paths being set.
  patches = [ ./gst-plugin-paths.patch ];

  NIX_CFLAGS_COMPILE =
    let gstPluginPaths =
          lib.makeSearchPathOutput "lib" "/lib/gstreamer-1.0"
          (with gst_all_1; [
            gstreamer
            gst-plugins-base
            gst-plugins-good
            gst-plugins-ugly
            gst-plugins-bad
            gst-libav
          ]);
    in toString [
      # This flag should be picked up through pkgconfig, but it isn't.
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
    pkgconfig
    extra-cmake-modules
    qttools
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else "Release"}"
  ];
}
