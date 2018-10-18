{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, doxygen, graphviz, valgrind
, glib, dbus, gst_all_1, libv4l, alsaLib, ffmpeg, libjack2, udev, libva, xorg
, sbc, SDL2, makeFontsConf, freefont_ttf
}:

let
  version = "0.2.3";

  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };
in stdenv.mkDerivation rec {
  name = "pipewire-${version}";

  src = fetchFromGitHub {
    owner = "PipeWire";
    repo = "pipewire";
    rev = version;
    sha256 = "1y04brfi5bv4y0hdyqzrcbayr674njf6a5hiwjfv2yi6lazkqv1k";
  };

  outputs = [ "out" "lib" "dev" "doc" ];

  nativeBuildInputs = [
    meson ninja pkgconfig doxygen graphviz valgrind
  ];
  buildInputs = [
    glib dbus gst_all_1.gst-plugins-base gst_all_1.gstreamer libv4l
    alsaLib ffmpeg libjack2 udev libva xorg.libX11 sbc SDL2
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dgstreamer=true"
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
