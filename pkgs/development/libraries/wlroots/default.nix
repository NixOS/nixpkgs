{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkg-config
, wayland-scanner
, libGL
, wayland
, wayland-protocols
, libinput
, libxkbcommon
, pixman
, libcap
, mesa
, xorg
, libpng
, ffmpeg_4
, ffmpeg
, hwdata
, seatd
, vulkan-loader
, glslang
, libliftoff
, libdisplay-info
, nixosTests

, enableXWayland ? true
, xwayland ? null
}:

let
  generic = { version, hash, extraBuildInputs ? [ ], extraNativeBuildInputs ? [ ], patches ? [ ], postPatch ? "" }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "wlroots";
      inherit version;

      inherit enableXWayland;

      src = fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = finalAttrs.version;
        inherit hash;
      };

      inherit patches postPatch;

      # $out for the library and $examples for the example programs (in examples):
      outputs = [ "out" "examples" ];

      strictDeps = true;
      depsBuildBuild = [ pkg-config ];

      nativeBuildInputs = [ meson ninja pkg-config wayland-scanner glslang ]
        ++ extraNativeBuildInputs;

      buildInputs = [
        libGL
        libcap
        libinput
        libpng
        libxkbcommon
        mesa
        pixman
        seatd
        vulkan-loader
        wayland
        wayland-protocols
        xorg.libX11
        xorg.xcbutilerrors
        xorg.xcbutilimage
        xorg.xcbutilrenderutil
        xorg.xcbutilwm
      ]
      ++ lib.optional finalAttrs.enableXWayland xwayland
      ++ extraBuildInputs;

      mesonFlags =
        lib.optional (!finalAttrs.enableXWayland) "-Dxwayland=disabled"
      ;

      postFixup = ''
        # Install ALL example programs to $examples:
        # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
        # screenshot output-layout multi-pointer rotation tablet touch pointer
        # simple
        mkdir -p $examples/bin
        cd ./examples
        for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
          cp "$binary" "$examples/bin/wlroots-$binary"
        done
      '';

      # Test via TinyWL (the "minimum viable product" Wayland compositor based on wlroots):
      passthru.tests.tinywl = nixosTests.tinywl;

      meta = {
        description = "A modular Wayland compositor library";
        longDescription = ''
          Pluggable, composable, unopinionated modules for building a Wayland
          compositor; or about 50,000 lines of code you were going to write anyway.
        '';
        inherit (finalAttrs.src.meta) homepage;
        changelog = "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${version}";
        license = lib.licenses.mit;
        platforms = lib.platforms.linux;
        maintainers = with lib.maintainers; [ primeos synthetica rewine ];
      };
    });

in
rec {
  wlroots_0_15 = generic {
    version = "0.15.1";
    hash = "sha256-MFR38UuB/wW7J9ODDUOfgTzKLse0SSMIRYTpEaEdRwM=";
    extraBuildInputs = [
      ffmpeg_4
    ];
  };

  wlroots_0_16 = generic {
    version = "0.16.2";
    hash = "sha256-JeDDYinio14BOl6CbzAPnJDOnrk4vgGNMN++rcy2ItQ=";
    postPatch = ''
      substituteInPlace backend/drm/meson.build \
        --replace /usr/share/hwdata/ ${hwdata}/share/hwdata/
    '';
    extraBuildInputs = [
      ffmpeg_4
    ];
  };

  wlroots_0_17 = generic {
    version = "0.17.1";
    hash = "sha256-Z0gWM7AQqJOSr2maUtjdgk/MF6pyeyFMMTaivgt+RMI=";
    extraBuildInputs = [
      ffmpeg
      hwdata
      libliftoff
      libdisplay-info
    ];
  };

  wlroots = wlroots_0_17;
}
