{ stdenv
, lib
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
, valgrind
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
, makeFontsConf
, callPackage
, nixosTests
, withMediaSession ? true
, libcameraSupport ? true
, libcamera
, libdrm
, gstreamerSupport ? true
, gst_all_1 ? null
, ffmpegSupport ? true
, ffmpeg ? null
, bluezSupport ? true
, bluez ? null
, sbc ? null
, libfreeaptx ? null
, ldacbt ? null
, fdk_aac ? null
, nativeHspSupport ? true
, nativeHfpSupport ? true
, ofonoSupport ? true
, hsphfpdSupport ? true
, pulseTunnelSupport ? true
, libpulseaudio ? null
, zeroconfSupport ? true
, avahi ? null
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [ ];
  };

  mesonEnable = b: if b then "enabled" else "disabled";
  mesonList = l: "[" + lib.concatStringsSep "," l + "]";

  self = stdenv.mkDerivation rec {
    pname = "pipewire";
    version = "0.3.39";

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
      sha256 = "sha256-peTS1+NuQxZg1rrv8DrnJW5BR9yReleqooIwhZWHLjM=";
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
      # Fix compilation on some architectures
      # XXX: REMOVE ON NEXT RELEASE
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/-/commit/651f0decea5f83730c271e9bed03cdd0048fcd49.diff";
        sha256 = "1bmpi5qn750mcspaw7m57ww0503sl9781jswqby4gr0f7c5wmqvj";
      })
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
      ncurses
      readline81
      udev
      vulkan-headers
      vulkan-loader
      webrtc-audio-processing
      valgrind
      SDL2
      systemd
    ] ++ lib.optionals gstreamerSupport [ gst_all_1.gst-plugins-base gst_all_1.gstreamer ]
    ++ lib.optionals libcameraSupport [ libcamera libdrm ]
    ++ lib.optional ffmpegSupport ffmpeg
    ++ lib.optionals bluezSupport [ bluez libfreeaptx ldacbt sbc fdk_aac ]
    ++ lib.optional pulseTunnelSupport libpulseaudio
    ++ lib.optional zeroconfSupport avahi;

    mesonFlags = [
      "-Ddocs=enabled"
      "-Dudevrulesdir=lib/udev/rules.d"
      "-Dinstalled_tests=enabled"
      "-Dinstalled_test_prefix=${placeholder "installedTests"}"
      "-Dpipewire_pulse_prefix=${placeholder "pulse"}"
      "-Dlibjack-path=${placeholder "jack"}/lib"
      "-Dlibcamera=${mesonEnable libcameraSupport}"
      "-Droc=disabled"
      "-Dlibpulse=${mesonEnable pulseTunnelSupport}"
      "-Davahi=${mesonEnable zeroconfSupport}"
      "-Dgstreamer=${mesonEnable gstreamerSupport}"
      "-Dffmpeg=${mesonEnable ffmpegSupport}"
      "-Dbluez5=${mesonEnable bluezSupport}"
      "-Dbluez5-backend-hsp-native=${mesonEnable nativeHspSupport}"
      "-Dbluez5-backend-hfp-native=${mesonEnable nativeHfpSupport}"
      "-Dbluez5-backend-ofono=${mesonEnable ofonoSupport}"
      "-Dbluez5-backend-hsphfpd=${mesonEnable hsphfpdSupport}"
      "-Dsysconfdir=/etc"
      "-Dpipewire_confdata_dir=${placeholder "lib"}/share/pipewire"
      "-Dsession-managers="
      "-Dvulkan=enabled"
    ];

    FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file

    doCheck = true;

    postUnpack = ''
      patchShebangs source/doc/strip-static.sh
      patchShebangs source/doc/input-filter.sh
      patchShebangs source/doc/input-filter-h.sh
      patchShebangs source/spa/tests/gen-cpp-test.py
    '';

    postInstall = ''
      mkdir $out/nix-support
      pushd $lib/share/pipewire
      for f in *.conf; do
        echo "Generating JSON from $f"
        $out/bin/spa-json-dump "$f" > "$out/nix-support/$f.json"
      done
      popd

      moveToOutput "share/systemd/user/pipewire-pulse.*" "$pulse"
      moveToOutput "lib/systemd/user/pipewire-pulse.*" "$pulse"
      moveToOutput "bin/pipewire-pulse" "$pulse"
    '';

    passthru = {
      updateScript = ./update.sh;
      tests = {
        installedTests = nixosTests.installed-tests.pipewire;

        # This ensures that all the paths used by the NixOS module are found.
        test-paths = callPackage ./test-paths.nix { package = self; } {
          paths-out = [
            "share/alsa/alsa.conf.d/50-pipewire.conf"
            "nix-support/client-rt.conf.json"
            "nix-support/client.conf.json"
            "nix-support/jack.conf.json"
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
