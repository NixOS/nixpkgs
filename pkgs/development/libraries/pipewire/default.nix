{ stdenv
, fetchFromGitLab
, fetchpatch
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
, libsndfile
, bluez
, vulkan-headers
, vulkan-loader
, libpulseaudio
, makeFontsConf
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [];
  };
in
stdenv.mkDerivation rec {
  pname = "pipewire";
  version = "0.3.6";

  outputs = [ "out" "lib" "dev" "doc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "pipewire";
    rev = version;
    sha256 = "0g149vyaigf4gzm764fcgxxci9niw19z0af9afs4diwq5xzr1qd3";
  };

  patches = [ (fetchpatch {
    # Brought by https://gitlab.freedesktop.org/pipewire/pipewire/-/merge_requests/263,
    # should be part of > 0.3.6
    url = "https://gitlab.freedesktop.org/pipewire/pipewire/-/commit/d1162f28efd502fcb973e172867970f5cc8d7a6b.patch";
    sha256 = "0ng34yin5726cvv0nll1b2xigyq6mj6j516l3xi0ys1i2g2fyby9";
  })];

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
    bluez
    dbus
    ffmpeg
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libjack2
    libpulseaudio
    libsndfile
    libva
    sbc
    udev
    vulkan-headers
    vulkan-loader
    xorg.libX11
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dman=false" # we don't have xmltoman
    "-Dgstreamer=true"
  ];

  FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Server and user space API to deal with multimedia pipelines";
    homepage = "https://pipewire.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jtojnar ];
  };
}
