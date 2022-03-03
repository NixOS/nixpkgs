{ stdenv
, lib
, buildPackages
, fetchFromGitLab
, fetchpatch
, removeReferencesTo
, python3
, meson
, ninja
, systemd
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
, libva
, libsndfile
, SDL2
, vulkan-headers
, vulkan-loader
, webrtc-audio-processing
, ncurses
, readline81 # meson can't find <7 as those versions don't have a .pc file
, lilv
, makeFontsConf
, callPackage
, nixosTests
, withValgrind ? lib.meta.availableOn stdenv.hostPlatform valgrind
, valgrind
, withMediaSession ? true
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
, fdk_aac
, nativeHspSupport ? true
, nativeHfpSupport ? true
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
}:

let
  mesonEnableFeature = b: if b then "enabled" else "disabled";
  mesonList = l: "[" + lib.concatStringsSep "," l + "]";

  self = stdenv.mkDerivation rec {
    pname = "pipewire";
    version = "0.3.48";

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
      sha256 = "sha256-+gk/MJ9YimHBwN2I42DRP+I2OqBFFtZ81Fd/l89HcSk=";
    };

    patches = [
      # Break up a dependency cycle between outputs.
      ./0040-alsa-profiles-use-libdir.patch
      # Change the path of the pipewire-pulse binary in the service definition.
      ./0050-pipewire-pulse-path.patch
      # Move installed tests into their own output.
      ./0070-installed-tests-path.patch
      # Add option for changing the config install directory
      ./0080-pipewire-config-dir.patch
      # Remove output paths from the comments in the config templates to break dependency cycles
      ./0090-pipewire-config-template-paths.patch
      # Place SPA data files in lib output to avoid dependency cycles
      ./0095-spa-data-dir.patch
    ];

    nativeBuildInputs = [
      docutils
      doxygen
      graphviz
      meson
      ninja
      pkg-config
      python3
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
      readline81
      udev
      vulkan-headers
      vulkan-loader
      webrtc-audio-processing
      SDL2
      systemd
    ] ++ lib.optionals gstreamerSupport [ gst_all_1.gst-plugins-base gst_all_1.gstreamer ]
    ++ lib.optionals libcameraSupport [ libcamera libdrm ]
    ++ lib.optional ffmpegSupport ffmpeg
    ++ lib.optionals bluezSupport [ bluez libfreeaptx ldacbt sbc fdk_aac ]
    ++ lib.optional pulseTunnelSupport libpulseaudio
    ++ lib.optional zeroconfSupport avahi
    ++ lib.optional raopSupport openssl
    ++ lib.optional rocSupport roc-toolkit
    ++ lib.optionals x11Support [ libcanberra xorg.libX11 xorg.libXfixes ];

    # Valgrind binary is required for running one optional test.
    checkInputs = lib.optional withValgrind valgrind;

    mesonFlags = [
      "-Ddocs=enabled"
      "-Dudevrulesdir=lib/udev/rules.d"
      "-Dinstalled_tests=enabled"
      "-Dinstalled_test_prefix=${placeholder "installedTests"}"
      "-Dpipewire_pulse_prefix=${placeholder "pulse"}"
      "-Dlibjack-path=${placeholder "jack"}/lib"
      "-Dlibcamera=${mesonEnableFeature libcameraSupport}"
      "-Droc=${mesonEnableFeature rocSupport}"
      "-Dlibpulse=${mesonEnableFeature pulseTunnelSupport}"
      "-Davahi=${mesonEnableFeature zeroconfSupport}"
      "-Dgstreamer=${mesonEnableFeature gstreamerSupport}"
      "-Dsystemd-system-service=enabled"
      "-Dffmpeg=${mesonEnableFeature ffmpegSupport}"
      "-Dbluez5=${mesonEnableFeature bluezSupport}"
      "-Dbluez5-backend-hsp-native=${mesonEnableFeature nativeHspSupport}"
      "-Dbluez5-backend-hfp-native=${mesonEnableFeature nativeHfpSupport}"
      "-Dbluez5-backend-ofono=${mesonEnableFeature ofonoSupport}"
      "-Dbluez5-backend-hsphfpd=${mesonEnableFeature hsphfpdSupport}"
      "-Dsysconfdir=/etc"
      "-Dpipewire_confdata_dir=${placeholder "lib"}/share/pipewire"
      "-Draop=${mesonEnableFeature raopSupport}"
      "-Dsession-managers="
      "-Dvulkan=enabled"
      "-Dx11=${mesonEnableFeature x11Support}"
    ];

    # Fontconfig error: Cannot load default config file
    FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

    doCheck = true;

    postUnpack = ''
      patchShebangs source/doc/input-filter.sh
      patchShebangs source/doc/input-filter-h.sh
    '';

    postInstall = ''
      mkdir $out/nix-support
      ${if (stdenv.hostPlatform == stdenv.buildPlatform) then ''
        pushd $lib/share/pipewire
        for f in *.conf; do
          echo "Generating JSON from $f"

          $out/bin/spa-json-dump "$f" > "$out/nix-support/$f.json"
        done
        popd
      '' else ''
        cp ${buildPackages.pipewire}/nix-support/*.json "$out/nix-support"
      ''}

      moveToOutput "share/systemd/user/pipewire-pulse.*" "$pulse"
      moveToOutput "lib/systemd/user/pipewire-pulse.*" "$pulse"
      moveToOutput "bin/pipewire-pulse" "$pulse"

      moveToOutput "bin/pw-jack" "$jack"
    '';

    passthru = {
      updateScript = ./update-pipewire.sh;
      tests = {
        installedTests = nixosTests.installed-tests.pipewire;

        # This ensures that all the paths used by the NixOS module are found.
        test-paths = callPackage ./test-paths.nix { package = self; } {
          paths-out = [
            "share/alsa/alsa.conf.d/50-pipewire.conf"
            "nix-support/client-rt.conf.json"
            "nix-support/client.conf.json"
            "nix-support/jack.conf.json"
            "nix-support/minimal.conf.json"
            "nix-support/pipewire.conf.json"
            "nix-support/pipewire-pulse.conf.json"
          ];
          paths-lib = [
            "lib/alsa-lib/libasound_module_pcm_pipewire.so"
            "share/alsa-card-profile/mixer"
          ];
        };
      };
    };

    meta = with lib; {
      description = "Server and user space API to deal with multimedia pipelines";
      homepage = "https://pipewire.org/";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ jtojnar kranzes ];
    };
  };

in
self
