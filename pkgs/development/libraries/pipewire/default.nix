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
, ldacbt
, liblc3
, fdk_aac
, libopus
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
, ffadoSupport ? stdenv.buildPlatform.canExecute stdenv.hostPlatform
, ffado
}:

let
  mesonEnableFeature = b: if b then "enabled" else "disabled";

  self = stdenv.mkDerivation rec {
    pname = "pipewire";
    version = "0.3.78";

    outputs = [
      "out"
      "lib"
      "pulse"
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
      sha256 = "sha256-tiVuab8kugp9ZOKL/m8uZQps/pcrVihwB3rRf6SGuzc=";
    };

    patches = [
      # Break up a dependency cycle between outputs.
      ./0040-alsa-profiles-use-libdir.patch
      # Change the path of the pipewire-pulse binary in the service definition.
      ./0050-pipewire-pulse-path.patch
      # Load libjack from a known location
      ./0060-libjack-path.patch
      # Move installed tests into their own output.
      ./0070-installed-tests-path.patch
      # Add option for changing the config install directory
      ./0080-pipewire-config-dir.patch
      # Remove output paths from the comments in the config templates to break dependency cycles
      ./0090-pipewire-config-template-paths.patch
      # Place SPA data files in lib output to avoid dependency cycles
      ./0095-spa-data-dir.patch
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
      libsndfile
      lilv
      ncurses
      readline
      udev
      vulkan-headers
      vulkan-loader
      webrtc-audio-processing
      tinycompress
    ] ++ (if enableSystemd then [ systemd ] else [ eudev ])
    ++ lib.optionals gstreamerSupport [ gst_all_1.gst-plugins-base gst_all_1.gstreamer ]
    ++ lib.optionals libcameraSupport [ libcamera libdrm ]
    ++ lib.optional ffmpegSupport ffmpeg
    ++ lib.optionals bluezSupport [ bluez libfreeaptx ldacbt liblc3 sbc fdk_aac libopus ]
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
      "-Dpipewire_pulse_prefix=${placeholder "pulse"}"
      "-Dlibjack-path=${placeholder "jack"}/lib"
      "-Dlibv4l2-path=${placeholder "out"}/lib"
      "-Dlibcamera=${mesonEnableFeature libcameraSupport}"
      "-Dlibffado=${mesonEnableFeature ffadoSupport}"
      "-Droc=${mesonEnableFeature rocSupport}"
      "-Dlibpulse=${mesonEnableFeature pulseTunnelSupport}"
      "-Davahi=${mesonEnableFeature zeroconfSupport}"
      "-Dgstreamer=${mesonEnableFeature gstreamerSupport}"
      "-Dsystemd-system-service=${mesonEnableFeature enableSystemd}"
      "-Dudev=${mesonEnableFeature (!enableSystemd)}"
      "-Dudevrulesdir=${placeholder "out"}/lib/udev/rules.d"
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
      "-Dsysconfdir=/etc"
      "-Dpipewire_confdata_dir=${placeholder "lib"}/share/pipewire"
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
    ];

    # Fontconfig error: Cannot load default config file
    FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

    doCheck = true;

    postUnpack = ''
      patchShebangs source/doc/input-filter.sh
      patchShebangs source/doc/input-filter-h.sh
    '';

    postInstall = ''
      ${lib.optionalString enableSystemd ''
        moveToOutput "share/systemd/user/pipewire-pulse.*" "$pulse"
        moveToOutput "lib/systemd/user/pipewire-pulse.*" "$pulse"
      ''}

      rm $out/bin/pipewire-pulse
      mkdir -p $pulse/bin
      ln -sf $out/bin/pipewire $pulse/bin/pipewire-pulse

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
