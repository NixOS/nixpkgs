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
, ffmpeg_3
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
, callPackage
, nixosTests
, ofonoSupport ? true
, nativeHspSupport ? true
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [];
  };
in
stdenv.mkDerivation rec {
  pname = "pipewire";
  version = "0.3.9";

  outputs = [ "out" "lib" "dev" "doc" "installedTests" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "pipewire";
    rev = version;
    sha256 = "0q781r32mnm3qy6xcdd2rnb8g50gdi7mi50zmdiq24s24sr8f8r9";
  };

  patches = [
    # Break up a dependency cycle between outputs.
    ./alsa-profiles-use-libdir.patch
    # Move installed tests into their own output.
    ./installed-tests-path.patch
  ];

  postPatch = ''
    substituteInPlace meson.build --subst-var-by installed_tests_dir "$installedTests"
  '';

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
    ffmpeg_3
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
    "-Dudevrulesdir=lib/udev/rules.d"
    "-Dinstalled_tests=true"
  ] ++ stdenv.lib.optional nativeHspSupport "-Dbluez5-backend-native=true"
  ++ stdenv.lib.optional ofonoSupport "-Dbluez5-backend-ofono=true";

  FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file

  doCheck = true;

  passthru.tests = {
    installedTests = nixosTests.installed-tests.pipewire;

    # This ensures that all the paths used by the NixOS module are found.
    test-paths = callPackage ./test-paths.nix {
      paths-out = [
        "share/alsa/alsa.conf.d/50-pipewire.conf"
      ];
      paths-lib = [
        "lib/alsa-lib/libasound_module_pcm_pipewire.so"
        "lib/pipewire-0.3/jack"
        "lib/pipewire-0.3/pulse"
        "share/alsa-card-profile/mixer"
      ];
    };
  };

  meta = with stdenv.lib; {
    description = "Server and user space API to deal with multimedia pipelines";
    homepage = "https://pipewire.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jtojnar ];
  };
}
