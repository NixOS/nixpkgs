{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, doxygen, graphviz, valgrind
, glib, dbus, gst_all_1, v4l_utils, alsaLib, ffmpeg, libjack2, libudev, libva, xlibs
, sbc, SDL2
}:

let
  version = "0.1.8";
in stdenv.mkDerivation rec {
  name = "pipewire-${version}";

  src = fetchFromGitHub {
    owner = "PipeWire";
    repo = "pipewire";
    rev = version;
    sha256 = "1nim8d1lsf6yxk97piwmsz686w84b09lk6cagbyjr9m3k2hwybqn";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [
    meson ninja pkgconfig doxygen graphviz valgrind
  ];
  buildInputs = [
    glib dbus gst_all_1.gst-plugins-base gst_all_1.gstreamer v4l_utils
    alsaLib ffmpeg libjack2 libudev libva xlibs.libX11 sbc SDL2
  ];

  patches = [
    ./fix-paths.patch
  ];

  mesonFlags = [
    "-Denable_docs=true"
    "-Denable_gstreamer=true"
  ];

  doCheck = true;
  checkPhase = "meson test";

  meta = with stdenv.lib; {
    description = "Server and user space API to deal with multimedia pipelines";
    homepage = http://pipewire.org/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jtojnar ];
  };
}
