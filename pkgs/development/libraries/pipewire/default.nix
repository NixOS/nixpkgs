{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, removeReferencesTo
, meson
, ninja
, systemd
, pkgconfig
, doxygen
, graphviz
, valgrind
, glib
, dbus
, alsaLib
, libjack2
, udev
, libva
, libsndfile
, vulkan-headers
, vulkan-loader
, makeFontsConf
, callPackage
, nixosTests
, gstreamerSupport ? true, gst_all_1 ? null
, ffmpegSupport ? true, ffmpeg ? null
, bluezSupport ? true, bluez ? null, sbc ? null, libopenaptx ? null, ldacbt ? null
, nativeHspSupport ? true
, ofonoSupport ? true
, hsphfpdSupport ? true
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [];
  };

  mesonBool = b: if b then "true" else "false";
in
stdenv.mkDerivation rec {
  pname = "pipewire";
  version = "0.3.18";

  outputs = [
    "out"
    "lib"
    "pulse"
    "jack"
    "dev"
    "doc"
    "installedTests"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "pipewire";
    rev = version;
    sha256 = "1yghhgs18yqrnd0b2r75l5n8yng962r1wszbsi01v6i9zib3jc9g";
  };

  patches = [
    # Break up a dependency cycle between outputs.
    ./alsa-profiles-use-libdir.patch
    # Move installed tests into their own output.
    ./installed-tests-path.patch
    # Change the path of the pipewire-pulse binary in the service definition.
    ./pipewire-pulse-path.patch
    # Add flag to specify configuration directory (different from the installation directory).
    ./pipewire-config-dir.patch
  ];

  nativeBuildInputs = [
    doxygen
    graphviz
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    alsaLib
    dbus
    glib
    libjack2
    libsndfile
    udev
    vulkan-headers
    vulkan-loader
    valgrind
    systemd
  ] ++ lib.optionals gstreamerSupport [ gst_all_1.gst-plugins-base gst_all_1.gstreamer ]
  ++ lib.optional ffmpegSupport ffmpeg
  ++ lib.optionals bluezSupport [ bluez libopenaptx ldacbt sbc ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dman=false" # we don't have xmltoman
    "-Dexamples=true" # only needed for `pipewire-media-session`
    "-Dudevrulesdir=lib/udev/rules.d"
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    "-Dpipewire_pulse_prefix=${placeholder "pulse"}"
    "-Dlibjack-path=${placeholder "jack"}/lib"
    "-Dgstreamer=${mesonBool gstreamerSupport}"
    "-Dffmpeg=${mesonBool ffmpegSupport}"
    "-Dbluez5=${mesonBool bluezSupport}"
    "-Dbluez5-backend-native=${mesonBool nativeHspSupport}"
    "-Dbluez5-backend-ofono=${mesonBool ofonoSupport}"
    "-Dbluez5-backend-hsphfpd=${mesonBool hsphfpdSupport}"
    "-Dpipewire_config_dir=/etc/pipewire"
  ];

  FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file

  doCheck = true;

  postInstall = ''
    moveToOutput "share/systemd/user/pipewire-pulse.*" "$pulse"
    moveToOutput "lib/systemd/user/pipewire-pulse.*" "$pulse"
    moveToOutput "bin/pipewire-pulse" "$pulse"
  '';

  passthru.tests = {
    installedTests = nixosTests.installed-tests.pipewire;

    # This ensures that all the paths used by the NixOS module are found.
    test-paths = callPackage ./test-paths.nix {
      paths-out = [
        "share/alsa/alsa.conf.d/50-pipewire.conf"
      ];
      paths-lib = [
        "lib/alsa-lib/libasound_module_pcm_pipewire.so"
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
