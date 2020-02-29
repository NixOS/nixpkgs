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
  version = "0.3.0";

  outputs = [ "out" "lib" "dev" "doc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "pipewire";
    rev = version;
    sha256 = "0wrgvn0sc7h2k5zwgwzffyzv70jknnlj9qg8cqfzjib516zz37lj";
  };

  patches = [
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/merge_requests/235
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/pipewire/pipewire/-/commit/42993d1402042dfbd023b3afe099c39709618daf.patch";
      sha256 = "1yvlajfz9nbksrjv80cg4af7w04n9z4ajncl2jg0d0mfxzpmv8vc";
    })
  ];

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
    homepage = https://pipewire.org/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jtojnar ];
  };
}
