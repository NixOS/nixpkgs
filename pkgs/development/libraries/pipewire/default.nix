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
  version = "0.3.2";

  outputs = [ "out" "lib" "dev" "doc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "pipewire";
    rev = version;
    sha256 = "U7lqvn2vMIxARNplzNX9H3Ztlfv1IH8LozJsq7JSEKs=";
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
  patches = [
      # fix SIGILL in fmt-ops: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/227
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/-/commit/1b3aaba206f48e75bb34ff0cd00321bd3d6db2b4.patch";
        sha256 = "08bmr9k2r0q4r7vhhm28k558nk3mz3jfnqswvq9mcj7p0srmfb4x";
      })
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
