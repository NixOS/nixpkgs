{ stdenv
, lib
, fetchFromGitLab
, python3
, meson
, ninja
, eudev
, systemd
, enableSystemd ? true
, pkg-config
, docutils
, doxygen
, graphviz
, glib
, dbus
, alsa-lib
, libjack2
, libusb1
, udev
, libsndfile
, vulkan-headers
, vulkan-loader
, webrtc-audio-processing
, webrtc-audio-processing_1
, ncurses
, readline # meson can't find <7 as those versions don't have a .pc file
, lilv
, makeFontsConf
, nixosTests
, withValgrind ? lib.meta.availableOn stdenv.hostPlatform valgrind
, valgrind
, libcameraSupport ? true
, libcamera
, libdrm
, gstreamerSupport ? true
, gst_all_1
, ffmpegSupport ? true
, ffmpeg
, bluezSupport ? true
, bluez
, sbc
, libfreeaptx
, liblc3
, fdk_aac
, libopus
, ldacbtSupport ? bluezSupport && lib.meta.availableOn stdenv.hostPlatform ldacbt
, ldacbt
, nativeHspSupport ? true
, nativeHfpSupport ? true
, nativeModemManagerSupport ? true
, modemmanager
, ofonoSupport ? true
, hsphfpdSupport ? true
, pulseTunnelSupport ? true
, libpulseaudio
, zeroconfSupport ? true
, avahi
, raopSupport ? true
, openssl
, rocSupport ? true
, roc-toolkit
, x11Support ? true
, libcanberra
, xorg
, mysofaSupport ? true
, libmysofa
, tinycompress
, ffadoSupport ? x11Support && stdenv.buildPlatform.canExecute stdenv.hostPlatform
, ffado
, libselinux
}:

# Bluetooth codec only makes sense if general bluetooth enabled
assert ldacbtSupport -> bluezSupport;

stdenv.mkDerivation(finalAttrs: {
  pname = "pipewire";
  version = "1.0.3";

  outputs = [
    "out"
    "jack"
    "dev"
    "doc"
    "man"
    "installedTests"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "pipewire";
    rev = finalAttrs.version;
    sha256 = "sha256-QVw7Q+RNo8BBy/uxoZeSQQn/vQcIl1bOiA9fYMR0+oI=";
  };

  patches = [
    # Load libjack from a known location
    ./0060-libjack-path.patch
    # Move installed tests into their own output.
    ./0070-installed-tests-path.patch
  ];

  strictDeps = true;
  nativeBuildInputs = [
    docutils
    doxygen
    graphviz
    meson
    ninja
    pkg-config
    python3
    glib
  ];

  buildInputs = [
    alsa-lib
    dbus
    glib
    libjack2
    libusb1
    libselinux
    libsndfile
    lilv
    ncurses
    readline
    udev
    vulkan-headers
    vulkan-loader
    tinycompress
  ] ++ (if enableSystemd then [ systemd ] else [ eudev ])
  ++ (if lib.meta.availableOn stdenv.hostPlatform webrtc-audio-processing_1 then [ webrtc-audio-processing_1 ] else [ webrtc-audio-processing ])
  ++ lib.optionals gstreamerSupport [ gst_all_1.gst-plugins-base gst_all_1.gstreamer ]
  ++ lib.optionals libcameraSupport [ libcamera libdrm ]
  ++ lib.optional ffmpegSupport ffmpeg
  ++ lib.optionals bluezSupport [ bluez libfreeaptx liblc3 sbc fdk_aac libopus ]
  ++ lib.optional ldacbtSupport ldacbt
  ++ lib.optional nativeModemManagerSupport modemmanager
  ++ lib.optional pulseTunnelSupport libpulseaudio
  ++ lib.optional zeroconfSupport avahi
  ++ lib.optional raopSupport openssl
  ++ lib.optional rocSupport roc-toolkit
  ++ lib.optionals x11Support [ libcanberra xorg.libX11 xorg.libXfixes ]
  ++ lib.optional mysofaSupport libmysofa
  ++ lib.optional ffadoSupport ffado;

  # Valgrind binary is required for running one optional test.
  nativeCheckInputs = lib.optional withValgrind valgrind;

  mesonFlags = [
    (lib.mesonEnable "docs" true)
    (lib.mesonOption "udevrulesdir" "lib/udev/rules.d")
    (lib.mesonEnable "installed_tests" true)
    (lib.mesonOption "installed_test_prefix" (placeholder "installedTests"))
    (lib.mesonOption "libjack-path" "${placeholder "jack"}/lib")
    (lib.mesonEnable "libcamera" libcameraSupport)
    (lib.mesonEnable "libffado" ffadoSupport)
    (lib.mesonEnable "roc" rocSupport)
    (lib.mesonEnable "libpulse" pulseTunnelSupport)
    (lib.mesonEnable "avahi" zeroconfSupport)
    (lib.mesonEnable "gstreamer" gstreamerSupport)
    (lib.mesonEnable "systemd-system-service" enableSystemd)
    (lib.mesonEnable "udev" (!enableSystemd))
    (lib.mesonEnable "ffmpeg" ffmpegSupport)
    (lib.mesonEnable "bluez5" bluezSupport)
    (lib.mesonEnable "bluez5-backend-hsp-native" nativeHspSupport)
    (lib.mesonEnable "bluez5-backend-hfp-native" nativeHfpSupport)
    (lib.mesonEnable "bluez5-backend-native-mm" nativeModemManagerSupport)
    (lib.mesonEnable "bluez5-backend-ofono" ofonoSupport)
    (lib.mesonEnable "bluez5-backend-hsphfpd" hsphfpdSupport)
    # source code is not easily obtainable
    (lib.mesonEnable "bluez5-codec-lc3plus" false)
    (lib.mesonEnable "bluez5-codec-lc3" bluezSupport)
    (lib.mesonEnable "bluez5-codec-ldac" ldacbtSupport)
    (lib.mesonOption "sysconfdir" "/etc")
    (lib.mesonEnable "raop" raopSupport)
    (lib.mesonOption "session-managers" "")
    (lib.mesonEnable "vulkan" true)
    (lib.mesonEnable "x11" x11Support)
    (lib.mesonEnable "x11-xfixes" x11Support)
    (lib.mesonEnable "libcanberra" x11Support)
    (lib.mesonEnable "libmysofa" mysofaSupport)
    (lib.mesonEnable "sdl2" false) # required only to build examples, causes dependency loop
    (lib.mesonBool "rlimits-install" false) # installs to /etc, we won't use this anyway
    (lib.mesonEnable "compress-offload" true)
    (lib.mesonEnable "man" true)
  ];

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  doCheck = true;

  postUnpack = ''
    patchShebangs source/doc/*.py
    patchShebangs source/doc/input-filter-h.sh
  '';

  postInstall = ''
    moveToOutput "bin/pw-jack" "$jack"
  '';

  passthru.tests.installed-tests = nixosTests.installed-tests.pipewire;

  meta = with lib; {
    description = "Server and user space API to deal with multimedia pipelines";
    changelog = "https://gitlab.freedesktop.org/pipewire/pipewire/-/releases/${version}";
    homepage = "https://pipewire.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kranzes k900 ];
  };
})
