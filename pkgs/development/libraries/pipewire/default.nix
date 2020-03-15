{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
, doxygen
, graphviz
, valgrind
, glib
, dbus
, gst_all_1
, alsaLib
, ffmpeg
, libjack2
, udev
, libva
, xorg
, sbc
, SDL2
, makeFontsConf
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [];
  };
in
stdenv.mkDerivation rec {
  pname = "pipewire";
  version = "0.2.7";

  outputs = [ "out" "lib" "dev" "doc" ];

  src = fetchFromGitHub {
    owner = "PipeWire";
    repo = "pipewire";
    rev = version;
    sha256 = "1q5wrqnhhs6r49p8yvkw1pl0cnsd4rndxy4h5lvdydwgf1civcwc";
  };

  nativeBuildInputs = [
    doxygen
    graphviz
    meson
    ninja
    pkgconfig
    valgrind
  ];

  buildInputs = [
    SDL2
    alsaLib
    dbus
    ffmpeg
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libjack2
    libva
    sbc
    udev
    xorg.libX11
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dgstreamer=enabled"
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
