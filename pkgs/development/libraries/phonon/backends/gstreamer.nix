{ stdenv, lib, fetchurl, cmake, gst_all_1, phonon, pkgconfig
, extra-cmake-modules, qtbase ? null, qtx11extras ? null, qt4 ? null
, withQt5 ? false
, debug ? false
}:

with lib;

let
  v = "4.9.0";
  pname = "phonon-backend-gstreamer";
in

assert withQt5 -> qtbase != null;
assert withQt5 -> qtx11extras != null;

stdenv.mkDerivation rec {
  name = "${pname}-${if withQt5 then "qt5" else "qt4"}-${v}";

  meta = with stdenv.lib; {
    homepage = http://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel ];
  };

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${v}/${pname}-${v}.tar.xz";
    sha256 = "1wc5p1rqglf0n1avp55s50k7fjdzdrhg0gind15k8796w7nfbhyf";
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
    in [
      # This flag should be picked up through pkgconfig, but it isn't.
      "-I${gst_all_1.gstreamer.dev}/lib/gstreamer-1.0/include"

      ''-DGST_PLUGIN_PATH_1_0="${gstPluginPaths}"''
    ];

  buildInputs = with gst_all_1;
    [ gstreamer gst-plugins-base phonon ]
    ++ (if withQt5 then [ qtbase qtx11extras ] else [ qt4 ]);

  # cleanup: the build system creates (empty) $out/$out/share/icons (double prefix)
  # if DESTDIR is unset
  DESTDIR="/";

  nativeBuildInputs = [ cmake pkgconfig ] ++ optional withQt5 extra-cmake-modules;

  cmakeFlags =
    [ "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else "Release"}" ]
    ++ optional withQt5 "-DPHONON_BUILD_PHONON4QT5=ON";
}
