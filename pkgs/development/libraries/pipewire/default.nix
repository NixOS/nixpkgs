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

  mesonBool = b: if b then "true" else "false";

  self = stdenv.mkDerivation rec {
    pname = "pipewire";
    version = "0.3.22";

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
      hash = "sha256:6SEOUivyehccVR5zt79Qw2rjN2KcO5x3TEejXVxRlvs=";
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

      # Various quality of life improvements that didn't make it into 0.3.22
      (fetchpatch {
        name = "0001-bluez5-include-a2dp-codec-profiles-in-route-profiles.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/df1dbee687c819095a6fddce3b24943f9ac47dbc.patch";
        sha256 = "sha256-MesteaIcfKMr53TdObEfqRyKEgalB1GEWpsTexawPgg=";
      })
      (fetchpatch {
        name = "0001-pulse-server-don-t-use-the-pending_sample-after-free.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/72acd752f68a35c40641262be1c69014170d0734.patch";
        sha256 = "sha256-F3+aVfOYH4SLTwWhdIKuNUo85NBoS+67vkUrcsaldSs=";
      })
      ./patches-0.3.22/0005-fix-some-warnings.patch
      (fetchpatch {
        name = "0006-spa-escape-double-quotes.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/6a219092818a7a7e357441256d8070ae77ac2d3a.patch";
        sha256 = "sha256-NUjxOSthe3Jw2LUrO11QnTWTx0PQNBJkQSv3ux58jZw=";
      })
      (fetchpatch {
        name = "0009-bluez5-volumes-need-to-be-distributed-to-all-channel.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/8c5ca000ef7fddd9be9cd2211d880736e97b956d.patch";
        sha256 = "sha256-9NhbYSXlNOYmoPg8tj561QHisaD216fBG7ccNIfoZ64=";
      })
      (fetchpatch {
        name = "0010-bluez5-set-the-right-volumes-on-the-node.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/930b411075a5c1b0d9ddcfe7dd2dbfdc27baab90.patch";
        sha256 = "sha256-xsL92H8wSrBzoxLtraCVxPZdXWTwj+j+O2XlfhcJ7IQ=";
      })
      (fetchpatch {
        name = "0011-bluez5-backend-native-Check-volume-values.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/7a5a94470453e0cbd3a087b1be2aa8960ff43c07.patch";
        sha256 = "sha256-HKWcfkwMmmlEB7l+SETJDsUZ2eLggcodtbNOpqY/wWY=";
      })
      (fetchpatch {
        name = "0012-media-session-don-t-switch-to-pro-audio-by-default.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/84fc63e60168e2c2f43875423899b4ae3bd89a7b.patch";
        sha256 = "sha256-tZwgBMZS+HJd0lrRji3aevbP/yJfvWYK60KMpfiFrOY=";
      })
      (fetchpatch {
        name = "0013-audioconvert-keep-better-track-of-param-changes.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/44919c83fc51aa5e1a22c903e841897c1b4d274c.patch";
        sha256 = "sha256-DIZUfEjUCaK4yY3k7/KLHv1igTKz6Ek4QbWECs1sr9E=";
      })
      (fetchpatch {
        name = "0018-pulse-server-print-encoding-name-in-format_info.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/4b591df145afa316e8e047764f9b98fc10cbacd9.patch";
        sha256 = "sha256-Dr6w6tI4R+6wrl0rVk9Eifw3YleuisVmXzsv+H2jtXc=";
      })
      (fetchpatch {
        name = "0019-pulse-server-handle-unsupported-formats.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/fcf00b3d352d931446a384a768b999520662b599.patch";
        sha256 = "sha256-kQ3vRoojLVTOJi8V4eODkZC8agsla2PjKf6sJnm/1C4=";
      })
      (fetchpatch {
        name = "0021-jack-handle-client-init-error-with-EIO.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/715a3a642a4f1c1f624e0a9dc0394b1819b69f93.patch";
        sha256 = "sha256-DglHcH9pHSWuVxZuLt8J+gDmxOaQSoiThVE2wePfH1I=";
      })
      (fetchpatch {
        name = "0022-pw-cli-always-output-to-stdout.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/91875c1fd8ece6b1b94130c50304b715654f8681.patch";
        sha256 = "sha256-3Sf/Tr39bdBihq/CFborm7GcBWtSvqO3KtRtFBcHcmc=";
      })
      (fetchpatch {
        name = "0024-policy-node-don-t-crash-without-metadata.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/3673265ae20d7b59e89cad6c5238c232796731b2.patch";
        sha256 = "sha256-YRdh1gqBYqa+sbSfHuJZ+Xc6w4QTOOpt/fppFNxsj+8=";
      })
      (fetchpatch {
        name = "0025-bluez5-route-shouldn-t-list-a2dp-profiles-when-not-c.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/a5dc2493dfccfc168cef01162f38f90e986b8af4.patch";
        sha256 = "sha256-zu7zqHIMOcxLAhvelKNWDB+804x+ocCo5FAMUSSOnVo=";
      })
      (fetchpatch {
        name = "0027-jack-apply-PIPEWIRE_PROPS-after-reading-config.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/149319819aa5d4e39770c35a0c00f6c2963e2bf3.patch";
        sha256 = "sha256-SwKQJkg8NIL9D0GAL6hnEgi8kvuToo1bpDm52adtKxA=";
      })
      (fetchpatch {
        name = "0038-jack-add-config-option-to-shorten-and-filter-names.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/d54da879bf5f9fa9009e1ab27e8d52eae3141764.patch";
        sha256 = "sha256-iYOmZTWNODHYWpYGfRTQhBLV1HeFOUvHN3Ta0f1ZS8M=";
      })
      (fetchpatch {
        name = "0046-jack-fix-names-of-our-ports.patch";
        url = "https://gitlab.freedesktop.org/pipewire/pipewire/commit/e340a44a357e4550e169bc8825c6aa8b4ceb76db.patch";
        sha256 = "sha256-rfv2IzgYyNB1s51eRFhJzZCyso6PIEj2qg9fpPpOZ5Q=";
      })
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
      mkdir -p $out/nix-support/etc/pipewire/media-session.
      for f in etc/pipewire/*.conf; do $out/bin/spa-json-dump "$f" > "$out/nix-support/$f.json"; done

      moveToOutput "share/systemd/user/pipewire-pulse.*" "$pulse"
      moveToOutput "lib/systemd/user/pipewire-pulse.*" "$pulse"
      moveToOutput "bin/pipewire-pulse" "$pulse"

      mkdir -p $mediaSession/nix-support/etc/pipewire/media-session.d
      for f in etc/pipewire/media-session.d/*.conf; do $out/bin/spa-json-dump "$f" > "$mediaSession/nix-support/$f.json"; done
      moveToOutput "bin/pipewire-media-session" "$mediaSession"
      moveToOutput "etc/pipewire/media-session.d/*.conf" "$mediaSession"
    '';

    passthru.tests = {
      installedTests = nixosTests.installed-tests.pipewire;

      # This ensures that all the paths used by the NixOS module are found.
      test-paths = callPackage ./test-paths.nix {
        paths-out = [
          "share/alsa/alsa.conf.d/50-pipewire.conf"
          "nix-support/etc/pipewire/client.conf.json"
          "nix-support/etc/pipewire/client-rt.conf.json"
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

    meta = with lib; {
      description = "Server and user space API to deal with multimedia pipelines";
      homepage = "https://pipewire.org/";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ jtojnar ];
    };
  };

in self
