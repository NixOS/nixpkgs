{
  stdenv,
  lib,
  testers,
  buildPackages,
  fetchFromGitLab,
  python3,
  meson,
  ninja,
  freebsd,
  elogind,
  libinotify-kqueue,
  epoll-shim,
  systemd,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, # enableSystemd=false maintained by maintainers.qyliss.
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
  fftwFloat,
  bluezSupport ? stdenv.hostPlatform.isLinux,
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
  ffadoSupport ?
    x11Support
    && lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform
    && lib.meta.availableOn stdenv.hostPlatform ffado,
  ffado,
  libselinux,
  libebur128,
}:

let
  modemmanagerSupport = lib.meta.availableOn stdenv.hostPlatform modemmanager;
  libcameraSupport = lib.meta.availableOn stdenv.hostPlatform libcamera;
  ldacbtSupport = lib.meta.availableOn stdenv.hostPlatform ldacbt;
  webrtcAudioProcessingSupport = lib.meta.availableOn stdenv.hostPlatform webrtc-audio-processing;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pipewire";
  version = "1.4.7";

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
    sha256 = "sha256-U9J7f6nDO4tp6OCBtBcZ9HP9KDKLfuuRWDEbgLL9Avs=";
  };

  patches = [
    # Load libjack from a known location
    ./0060-libjack-path.patch
    # Move installed tests into their own output.
    ./0070-installed-tests-path.patch
  ];

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
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
    dbus
    ffmpeg
    fftwFloat
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libebur128
    libjack2
    libmysofa
    libopus
    libpulseaudio
    libusb1
    libsndfile
    lilv
    ncurses
    readline
  ]
  ++ (
    if enableSystemd then
      [ systemd ]
    else if stdenv.hostPlatform.isLinux then
      [
        elogind
        udev
      ]
    else
      [ ]
  )
  ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    libinotify-kqueue
    epoll-shim
    freebsd.libstdthreads
  ]
  ++ lib.optional webrtcAudioProcessingSupport webrtc-audio-processing
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
  ++ lib.optional ldacbtSupport ldacbt
  ++ lib.optional libcameraSupport libcamera
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
    xorg.libxcb
    xorg.libXfixes
  ]
  ++ lib.optionals bluezSupport [
    bluez
    libfreeaptx
    liblc3
    sbc
    fdk_aac
  ]
  ++ lib.optional ffadoSupport ffado
  ++ lib.optional stdenv.hostPlatform.isLinux libselinux
  ++ lib.optional modemmanagerSupport modemmanager;

  # Valgrind binary is required for running one optional test.
  nativeCheckInputs = lib.optional (lib.meta.availableOn stdenv.hostPlatform valgrind) valgrind;

  mesonFlags = [
    (lib.mesonEnable "pipewire-alsa" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "alsa" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "docs" true)
    (lib.mesonOption "udevrulesdir" "lib/udev/rules.d")
    (lib.mesonEnable "installed_tests" true)
    (lib.mesonOption "installed_test_prefix" (placeholder "installedTests"))
    (lib.mesonOption "libjack-path" "${placeholder "jack"}/lib")
    (lib.mesonEnable "echo-cancel-webrtc" webrtcAudioProcessingSupport)
    (lib.mesonEnable "libcamera" (lib.meta.availableOn stdenv.hostPlatform libcamera))
    (lib.mesonEnable "libffado" ffadoSupport)
    (lib.mesonEnable "roc" rocSupport)
    (lib.mesonEnable "libpulse" true)
    (lib.mesonEnable "avahi" zeroconfSupport)
    (lib.mesonEnable "gstreamer" true)
    (lib.mesonEnable "gstreamer-device-provider" true)
    (lib.mesonOption "logind-provider" (if enableSystemd then "libsystemd" else "libelogind"))
    (lib.mesonEnable "logind" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "selinux" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "avb" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "v4l2" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "pipewire-v4l2" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "systemd" enableSystemd)
    (lib.mesonEnable "systemd-system-service" enableSystemd)
    (lib.mesonEnable "udev" (!enableSystemd && stdenv.hostPlatform.isLinux))
    (lib.mesonEnable "ffmpeg" true)
    (lib.mesonEnable "pw-cat-ffmpeg" true)
    (lib.mesonEnable "bluez5" bluezSupport)
    (lib.mesonEnable "bluez5-backend-hsp-native" bluezSupport)
    (lib.mesonEnable "bluez5-backend-hfp-native" bluezSupport)
    (lib.mesonEnable "bluez5-backend-native-mm" bluezSupport)
    (lib.mesonEnable "bluez5-backend-ofono" bluezSupport)
    (lib.mesonEnable "bluez5-backend-hsphfpd" bluezSupport)
    # source code is not easily obtainable
    (lib.mesonEnable "bluez5-codec-lc3plus" false)
    (lib.mesonEnable "bluez5-codec-lc3" bluezSupport)
    (lib.mesonEnable "bluez5-codec-ldac" (bluezSupport && ldacbtSupport))
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
  doInstallCheck = true;

  postUnpack = ''
    patchShebangs ${finalAttrs.src.name}/doc/*.py
    patchShebangs ${finalAttrs.src.name}/doc/input-filter-h.sh
  '';

  postInstall = ''
    moveToOutput "bin/pw-jack" "$jack"
  '';

  passthru.tests = {
    installed-tests = nixosTests.installed-tests.pipewire;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Server and user space API to deal with multimedia pipelines";
    changelog = "https://gitlab.freedesktop.org/pipewire/pipewire/-/releases/${finalAttrs.version}";
    homepage = "https://pipewire.org/";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.freebsd;
    maintainers = with maintainers; [
      kranzes
      k900
    ];
    pkgConfigModules = [
      "libpipewire-0.3"
      "libspa-0.2"
    ];
  };
})
