{
  stdenv,
  lib,
  fetchFromGitLab,
  python3,
  meson,
  ninja,
  elogind,
  systemd,
  enableSystemd ? true, # enableSystemd=false maintained by maintainers.qyliss.
  pkg-config,
  docutils,
  doxygen,
  graphviz,
  glib,
  dbus,
  alsa-lib,
  libjack2,
  libusb1,
  udev,
  libsndfile,
  vulkanSupport ? true,
  vulkan-headers,
  vulkan-loader,
  webrtc-audio-processing,
  webrtc-audio-processing_1,
  ncurses,
  readline, # meson can't find <7 as those versions don't have a .pc file
  lilv,
  makeFontsConf,
  nixosTests,
  valgrind,
  libcamera,
  libdrm,
  gst_all_1,
  ffmpeg,
  bluez,
  sbc,
  libfreeaptx,
  liblc3,
  fdk_aac,
  libopus,
  ldacbt,
  modemmanager,
  libpulseaudio,
  zeroconfSupport ? true,
  avahi,
  raopSupport ? true,
  openssl,
  rocSupport ? true,
  roc-toolkit,
  x11Support ? true,
  libcanberra,
  xorg,
  libmysofa,
  ffadoSupport ? x11Support && lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform,
  ffado,
  libselinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pipewire";
  version = "1.2.6";

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
    sha256 = "sha256-AmrbA1YQBeETLC9u9rQ2f85rG9TASvcbCZ/Xlz7ICdY=";
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

  buildInputs =
    [
      alsa-lib
      bluez
      dbus
      fdk_aac
      ffmpeg
      glib
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
      libcamera
      libjack2
      libfreeaptx
      liblc3
      libmysofa
      libopus
      libpulseaudio
      libusb1
      libselinux
      libsndfile
      lilv
      modemmanager
      ncurses
      readline
      sbc
    ]
    ++ (
      if enableSystemd then
        [ systemd ]
      else
        [
          elogind
          udev
        ]
    )
    ++ (
      if lib.meta.availableOn stdenv.hostPlatform webrtc-audio-processing_1 then
        [ webrtc-audio-processing_1 ]
      else
        [ webrtc-audio-processing ]
    )
    ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform ldacbt) ldacbt
    ++ lib.optional zeroconfSupport avahi
    ++ lib.optional raopSupport openssl
    ++ lib.optional rocSupport roc-toolkit
    ++ lib.optionals vulkanSupport [
      libdrm
      vulkan-headers
      vulkan-loader
    ]
    ++ lib.optionals x11Support [
      libcanberra
      xorg.libX11
      xorg.libXfixes
    ]
    ++ lib.optional ffadoSupport ffado;

  # Valgrind binary is required for running one optional test.
  nativeCheckInputs = lib.optional (lib.meta.availableOn stdenv.hostPlatform valgrind) valgrind;

  mesonFlags = [
    (lib.mesonEnable "docs" true)
    (lib.mesonOption "udevrulesdir" "lib/udev/rules.d")
    (lib.mesonEnable "installed_tests" true)
    (lib.mesonOption "installed_test_prefix" (placeholder "installedTests"))
    (lib.mesonOption "libjack-path" "${placeholder "jack"}/lib")
    (lib.mesonEnable "libcamera" true)
    (lib.mesonEnable "libffado" ffadoSupport)
    (lib.mesonEnable "roc" rocSupport)
    (lib.mesonEnable "libpulse" true)
    (lib.mesonEnable "avahi" zeroconfSupport)
    (lib.mesonEnable "gstreamer" true)
    (lib.mesonEnable "gstreamer-device-provider" true)
    (lib.mesonOption "logind-provider" (if enableSystemd then "libsystemd" else "libelogind"))
    (lib.mesonEnable "systemd" enableSystemd)
    (lib.mesonEnable "systemd-system-service" enableSystemd)
    (lib.mesonEnable "udev" (!enableSystemd))
    (lib.mesonEnable "ffmpeg" true)
    (lib.mesonEnable "pw-cat-ffmpeg" true)
    (lib.mesonEnable "bluez5" true)
    (lib.mesonEnable "bluez5-backend-hsp-native" true)
    (lib.mesonEnable "bluez5-backend-hfp-native" true)
    (lib.mesonEnable "bluez5-backend-native-mm" true)
    (lib.mesonEnable "bluez5-backend-ofono" true)
    (lib.mesonEnable "bluez5-backend-hsphfpd" true)
    # source code is not easily obtainable
    (lib.mesonEnable "bluez5-codec-lc3plus" false)
    (lib.mesonEnable "bluez5-codec-lc3" true)
    (lib.mesonEnable "bluez5-codec-ldac" (lib.meta.availableOn stdenv.hostPlatform ldacbt))
    (lib.mesonEnable "opus" true)
    (lib.mesonOption "sysconfdir" "/etc")
    (lib.mesonEnable "raop" raopSupport)
    (lib.mesonOption "session-managers" "")
    (lib.mesonEnable "vulkan" vulkanSupport)
    (lib.mesonEnable "x11" x11Support)
    (lib.mesonEnable "x11-xfixes" x11Support)
    (lib.mesonEnable "libcanberra" x11Support)
    (lib.mesonEnable "libmysofa" true)
    (lib.mesonEnable "sdl2" false) # required only to build examples, causes dependency loop
    (lib.mesonBool "rlimits-install" false) # installs to /etc, we won't use this anyway
    (lib.mesonEnable "compress-offload" true)
    (lib.mesonEnable "man" true)
    (lib.mesonEnable "snap" false) # we don't currently have a working snapd
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
    changelog = "https://gitlab.freedesktop.org/pipewire/pipewire/-/releases/${finalAttrs.version}";
    homepage = "https://pipewire.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      kranzes
      k900
    ];
  };
})
