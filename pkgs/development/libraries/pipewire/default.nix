{ stdenv
, lib
, buildPackages
, fetchFromGitLab
, fetchpatch
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
, callPackage
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

let
  mesonEnableFeature = b: if b then "enabled" else "disabled";

  self = stdenv.mkDerivation rec {
    pname = "pipewire";
    version = "1.0.0";

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
      rev = version;
      sha256 = "sha256-mfnMluxJAxDbB6JlIM6HJ0zg7e1q3ia3uFbht6zeHCk=";
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
      "-Ddocs=enabled"
      "-Dudevrulesdir=lib/udev/rules.d"
      "-Dinstalled_tests=enabled"
      "-Dinstalled_test_prefix=${placeholder "installedTests"}"
      "-Dlibjack-path=${placeholder "jack"}/lib"
      "-Dlibcamera=${mesonEnableFeature libcameraSupport}"
      "-Dlibffado=${mesonEnableFeature ffadoSupport}"
      "-Droc=${mesonEnableFeature rocSupport}"
      "-Dlibpulse=${mesonEnableFeature pulseTunnelSupport}"
      "-Davahi=${mesonEnableFeature zeroconfSupport}"
      "-Dgstreamer=${mesonEnableFeature gstreamerSupport}"
      "-Dsystemd-system-service=${mesonEnableFeature enableSystemd}"
      "-Dudev=${mesonEnableFeature (!enableSystemd)}"
      "-Dffmpeg=${mesonEnableFeature ffmpegSupport}"
      "-Dbluez5=${mesonEnableFeature bluezSupport}"
      "-Dbluez5-backend-hsp-native=${mesonEnableFeature nativeHspSupport}"
      "-Dbluez5-backend-hfp-native=${mesonEnableFeature nativeHfpSupport}"
      "-Dbluez5-backend-native-mm=${mesonEnableFeature nativeModemManagerSupport}"
      "-Dbluez5-backend-ofono=${mesonEnableFeature ofonoSupport}"
      "-Dbluez5-backend-hsphfpd=${mesonEnableFeature hsphfpdSupport}"
      # source code is not easily obtainable
      "-Dbluez5-codec-lc3plus=disabled"
      "-Dbluez5-codec-lc3=${mesonEnableFeature bluezSupport}"
      "-Dbluez5-codec-ldac=${mesonEnableFeature ldacbtSupport}"
      "-Dsysconfdir=/etc"
      "-Draop=${mesonEnableFeature raopSupport}"
      "-Dsession-managers="
      "-Dvulkan=enabled"
      "-Dx11=${mesonEnableFeature x11Support}"
      "-Dx11-xfixes=${mesonEnableFeature x11Support}"
      "-Dlibcanberra=${mesonEnableFeature x11Support}"
      "-Dlibmysofa=${mesonEnableFeature mysofaSupport}"
      "-Dsdl2=disabled" # required only to build examples, causes dependency loop
      "-Drlimits-install=false" # installs to /etc, we won't use this anyway
      "-Dcompress-offload=enabled"
      "-Dman=enabled"
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
  };

in
self
