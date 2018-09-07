{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, doxygen, graphviz, valgrind
, glib, dbus, gst_all_1, v4l_utils, alsaLib, ffmpeg, libjack2, udev, libva, xorg
, sbc, SDL2, makeFontsConf, freefont_ttf
}:

let
  version = "0.1.9";

  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };
in stdenv.mkDerivation rec {
  name = "pipewire-${version}";

  src = fetchFromGitHub {
    owner = "PipeWire";
    repo = "pipewire";
    rev = version;
    sha256 = "0r9mgwbggnnijhdz49fnv0qdka364xn1h8yml2jakyqpfrm3i2nm";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [
    meson ninja pkgconfig doxygen graphviz valgrind
  ];
  buildInputs = [
    glib dbus gst_all_1.gst-plugins-base gst_all_1.gstreamer v4l_utils
    alsaLib ffmpeg libjack2 udev libva xorg.libX11 sbc SDL2
  ];

  mesonFlags = [
    "-Denable_docs=true"
    "-Denable_gstreamer=true"
  ];

  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";

  FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Server and user space API to deal with multimedia pipelines";
    homepage = https://pipewire.org/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jtojnar ];
  };
}
