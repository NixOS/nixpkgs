{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
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
, vulkan-headers
, vulkan-loader
, ncurses
, makeFontsConf
, callPackage
, nixosTests
, python3
, runCommand
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

  runPythonCommand = name: buildCommandPython: runCommand name {
    nativeBuildInputs = [ python3 ];
      inherit buildCommandPython;
  } ''
    exec python3 -c "$buildCommandPython"
  '';

  mesonBool = b: if b then "true" else "false";

  self = stdenv.mkDerivation rec {
    pname = "pipewire";
    version = "0.3.21";

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
      hash = "sha256:2YJzPTMPIoQQeNja3F53SD4gtpdSlbD/i77hBWiQfuQ=";
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
      systemd
    ] ++ lib.optionals gstreamerSupport [ gst_all_1.gst-plugins-base gst_all_1.gstreamer ]
    ++ lib.optional ffmpegSupport ffmpeg
    ++ lib.optionals bluezSupport [ bluez libopenaptx ldacbt sbc fdk_aac ];

    mesonFlags = [
      "-Ddocs=true"
      "-Dman=false" # we don't have xmltoman
      "-Dexamples=${mesonBool withMediaSession}" # only needed for `pipewire-media-session`
      "-Dudevrulesdir=lib/udev/rules.d"
      "-Dinstalled_tests=true"
      "-Dinstalled_test_prefix=${placeholder "installedTests"}"
      "-Dpipewire_pulse_prefix=${placeholder "pulse"}"
      "-Dlibjack-path=${placeholder "jack"}/lib"
      "-Dgstreamer=${mesonBool gstreamerSupport}"
      "-Dffmpeg=${mesonBool ffmpegSupport}"
      "-Dbluez5=${mesonBool bluezSupport}"
      "-Dbluez5-backend-hsp-native=${mesonBool nativeHspSupport}"
      "-Dbluez5-backend-hfp-native=${mesonBool nativeHfpSupport}"
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

    passthru = {
      filesInstalledToEtc = [
        "pipewire/pipewire.conf"
      ] ++ lib.optionals withMediaSession [
        "pipewire/media-session.d/alsa-monitor.conf"
        "pipewire/media-session.d/bluez-monitor.conf"
        "pipewire/media-session.d/media-session.conf"
        "pipewire/media-session.d/v4l2-monitor.conf"
      ];

      tests = let
        listToPy = list: "[${lib.concatMapStringsSep ", " (f: "'${f}'") list}]";
      in {
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

        passthruMatches = runPythonCommand "fwupd-test-passthru-matches" ''
          import itertools
          import configparser
          import os
          import pathlib
          etc = '${self}/etc'
          package_etc = set(itertools.chain.from_iterable([[os.path.relpath(os.path.join(prefix, file), etc) for file in files] for (prefix, dirs, files) in os.walk(etc)]))
          passthru_etc = set(${listToPy passthru.filesInstalledToEtc})
          assert len(package_etc - passthru_etc) == 0, f'pipewire package contains the following paths in /etc that are not listed in passthru.filesInstalledToEtc: {package_etc - passthru_etc}'
          assert len(passthru_etc - package_etc) == 0, f'pipewire package lists the following paths in passthru.filesInstalledToEtc that are not contained in /etc: {passthru_etc - package_etc}'
          config = configparser.RawConfigParser()
          config.read('${self}/etc/fwupd/daemon.conf')
          pathlib.Path(os.getenv('out')).touch()
        '';
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
