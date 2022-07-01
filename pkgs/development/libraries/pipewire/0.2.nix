{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, doxygen, graphviz
, glib, dbus, gst_all_1, alsa-lib, ffmpeg_4, libjack2, udev, libva, xorg
, sbc, SDL2, makeFontsConf
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [ ];
  };
in stdenv.mkDerivation rec {
  pname = "pipewire";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "PipeWire";
    repo = "pipewire";
    rev = version;
    sha256 = "1q5wrqnhhs6r49p8yvkw1pl0cnsd4rndxy4h5lvdydwgf1civcwc";
  };

  outputs = [ "out" "lib" "dev" "doc" ];

  nativeBuildInputs = [
    meson ninja pkg-config doxygen graphviz
  ];
  buildInputs = [
    glib dbus gst_all_1.gst-plugins-base gst_all_1.gstreamer
    alsa-lib ffmpeg_4 libjack2 udev libva xorg.libX11 sbc SDL2
  ];

  # Workaround build on gcc-10+ and clang11+:
  #  spa/plugins/bluez5/libspa-bluez5.so.p/bluez5-monitor.c.o:(.bss+0x0):
  #    multiple definition of `spa_a2dp_sink_factory'
  NIX_CFLAGS_COMPILE = [ "-fcommon" ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dgstreamer=enabled"
  ];

  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";

  FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file

  doCheck = true;

  meta = with lib; {
    description = "Server and user space API to deal with multimedia pipelines";
    homepage = "https://pipewire.org/";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jtojnar ];
  };
}
