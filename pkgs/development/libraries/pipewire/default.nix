{ stdenv
, lib
, fetchFromGitLab
, removeReferencesTo
, meson
, ninja
, systemd
, pkg-config
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
, SDL2
, vulkan-headers
, vulkan-loader
, ncurses
, makeFontsConf
, callPackage
, nixosTests
, withMediaSession ? true
, gstreamerSupport ? true, gst_all_1 ? null
, ffmpegSupport ? true, ffmpeg ? null
, bluezSupport ? true, bluez ? null, sbc ? null, libopenaptx ? null, ldacbt ? null, fdk_aac ? null
, nativeHspSupport ? true
, nativeHfpSupport ? true
, ofonoSupport ? true
, hsphfpdSupport ? true
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [];
  };

  mesonEnable = b: if b then "enabled" else "disabled";

  self = stdenv.mkDerivation rec {
    pname = "pipewire";
    version = "0.3.26";

    outputs = [
      "out"
      "lib"
      "pulse"
      "jack"
      "dev"
      "doc"
      "mediaSession"
      "installedTests"
    ];

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "pipewire";
      rev = version;
      sha256 = "sha256-s9+70XXMN4K3yDVwIu+L15gL6rFlpRNVQpeekZQOEec=";
    };

    patches = [
      # Break up a dependency cycle between outputs.
      ./0040-alsa-profiles-use-libdir.patch
      # Change the path of the pipewire-pulse binary in the service definition.
      ./0050-pipewire-pulse-path.patch
      # Change the path of the pipewire-media-session binary in the service definition.
      ./0055-pipewire-media-session-path.patch
      # Move installed tests into their own output.
      ./0070-installed-tests-path.patch
      # Add flag to specify configuration directory (different from the installation directory).
      ./0080-pipewire-config-dir.patch
    ];

    nativeBuildInputs = [
      doxygen
      graphviz
      meson
      ninja
      pkg-config
    ];

    buildInputs = [
      alsaLib
      dbus
      glib
      libjack2
      libsndfile
      ncurses
      udev
      vulkan-headers
      vulkan-loader
      valgrind
      SDL2
      systemd
    ] ++ lib.optionals gstreamerSupport [ gst_all_1.gst-plugins-base gst_all_1.gstreamer ]
    ++ lib.optional ffmpegSupport ffmpeg
    ++ lib.optionals bluezSupport [ bluez libopenaptx ldacbt sbc fdk_aac ];

    mesonFlags = [
      "-Ddocs=enabled"
      "-Dman=disabled" # we don't have xmltoman
      "-Dexamples=${mesonEnable withMediaSession}" # only needed for `pipewire-media-session`
      "-Dudevrulesdir=lib/udev/rules.d"
      "-Dinstalled_tests=enabled"
      "-Dinstalled_test_prefix=${placeholder "installedTests"}"
      "-Dpipewire_pulse_prefix=${placeholder "pulse"}"
      "-Dmedia-session-prefix=${placeholder "mediaSession"}"
      "-Dlibjack-path=${placeholder "jack"}/lib"
      "-Dlibcamera=disabled"
      "-Dgstreamer=${mesonEnable gstreamerSupport}"
      "-Dffmpeg=${mesonEnable ffmpegSupport}"
      "-Dbluez5=${mesonEnable bluezSupport}"
      "-Dbluez5-backend-hsp-native=${mesonEnable nativeHspSupport}"
      "-Dbluez5-backend-hfp-native=${mesonEnable nativeHfpSupport}"
      "-Dbluez5-backend-ofono=${mesonEnable ofonoSupport}"
      "-Dbluez5-backend-hsphfpd=${mesonEnable hsphfpdSupport}"
      "-Dpipewire_config_dir=/etc/pipewire"
    ];

    FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file

    doCheck = true;

    postInstall = ''
      pushd .
      cd $out
      mkdir -p $out/nix-support/etc/pipewire
      for f in etc/pipewire/*.conf; do bin/spa-json-dump "$f" > "$out/nix-support/$f.json"; done

      mkdir -p $mediaSession/nix-support/etc/pipewire/media-session.d
      for f in etc/pipewire/media-session.d/*.conf; do bin/spa-json-dump "$f" > "$mediaSession/nix-support/$f.json"; done
      popd

      moveToOutput "etc/pipewire/media-session.d/*.conf" "$mediaSession"
      moveToOutput "share/systemd/user/pipewire-media-session.*" "$mediaSession"
      moveToOutput "lib/systemd/user/pipewire-media-session.*" "$mediaSession"
      moveToOutput "bin/pipewire-media-session" "$mediaSession"

      moveToOutput "share/systemd/user/pipewire-pulse.*" "$pulse"
      moveToOutput "lib/systemd/user/pipewire-pulse.*" "$pulse"
      moveToOutput "bin/pipewire-pulse" "$pulse"
    '';

    passthru = {
      updateScript = ./update.sh;
      tests = {
        installedTests = nixosTests.installed-tests.pipewire;

        # This ensures that all the paths used by the NixOS module are found.
        test-paths = callPackage ./test-paths.nix {
          paths-out = [
            "share/alsa/alsa.conf.d/50-pipewire.conf"
            "nix-support/etc/pipewire/client.conf.json"
            "nix-support/etc/pipewire/jack.conf.json"
            "nix-support/etc/pipewire/pipewire.conf.json"
            "nix-support/etc/pipewire/pipewire-pulse.conf.json"
          ];
          paths-out-media-session = [
            "nix-support/etc/pipewire/media-session.d/alsa-monitor.conf.json"
            "nix-support/etc/pipewire/media-session.d/bluez-monitor.conf.json"
            "nix-support/etc/pipewire/media-session.d/media-session.conf.json"
            "nix-support/etc/pipewire/media-session.d/v4l2-monitor.conf.json"
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
      maintainers = with maintainers; [ jtojnar ];
    };
  };

in self
