{ lib
, stdenv
, fetchFromGitLab
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
, hwdata
, seatd
, vulkan-loader
, glslang
, nixosTests

, enableXWayland ? true
, xwayland ? null
}:

let
  generic = { version, hash, extraBuildInputs ? [ ], extraNativeBuildInputs ? [ ], extraPatch ? "" }:
<<<<<<< HEAD
    stdenv.mkDerivation (finalAttrs: {
      pname = "wlroots";
      inherit version;

      inherit enableXWayland;

=======
    stdenv.mkDerivation rec {
      pname = "wlroots";
      inherit version;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      src = fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
<<<<<<< HEAD
        rev = finalAttrs.version;
=======
        rev = version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        inherit hash;
      };

      postPatch = extraPatch;

      # $out for the library and $examples for the example programs (in examples):
      outputs = [ "out" "examples" ];

      strictDeps = true;
      depsBuildBuild = [ pkg-config ];

<<<<<<< HEAD
      nativeBuildInputs = [ meson ninja pkg-config wayland-scanner glslang ]
=======
      nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        ++ extraNativeBuildInputs;

      buildInputs = [
        ffmpeg_4
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
<<<<<<< HEAD
      ++ lib.optional finalAttrs.enableXWayland xwayland
      ++ extraBuildInputs;

      mesonFlags =
        lib.optional (!finalAttrs.enableXWayland) "-Dxwayland=disabled"
=======
      ++ lib.optional enableXWayland xwayland
      ++ extraBuildInputs;

      mesonFlags =
        lib.optional (!enableXWayland) "-Dxwayland=disabled"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

      meta = with lib; {
        description = "A modular Wayland compositor library";
        longDescription = ''
          Pluggable, composable, unopinionated modules for building a Wayland
          compositor; or about 50,000 lines of code you were going to write anyway.
        '';
<<<<<<< HEAD
        inherit (finalAttrs.src.meta) homepage;
=======
        inherit (src.meta) homepage;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        changelog = "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${version}";
        license = licenses.mit;
        platforms = platforms.linux;
        maintainers = with maintainers; [ primeos synthetica ];
      };
<<<<<<< HEAD
    });

in
rec {
  wlroots_0_15 = generic {
    version = "0.15.1";
    hash = "sha256-MFR38UuB/wW7J9ODDUOfgTzKLse0SSMIRYTpEaEdRwM=";
=======
    };

in
rec {
  wlroots_0_14 = generic {
    version = "0.14.1";
    hash = "sha256-wauk7TCL/V7fxjOZY77KiPbfydIc9gmOiYFOuum4UOs=";
  };

  wlroots_0_15 = generic {
    version = "0.15.1";
    hash = "sha256-MFR38UuB/wW7J9ODDUOfgTzKLse0SSMIRYTpEaEdRwM=";
    extraBuildInputs = [ vulkan-loader ];
    extraNativeBuildInputs = [ glslang ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  wlroots_0_16 = generic {
    version = "0.16.2";
    hash = "sha256-JeDDYinio14BOl6CbzAPnJDOnrk4vgGNMN++rcy2ItQ=";
<<<<<<< HEAD
=======
    extraBuildInputs = [ vulkan-loader ];
    extraNativeBuildInputs = [ glslang ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    extraPatch = ''
      substituteInPlace backend/drm/meson.build \
        --replace /usr/share/hwdata/ ${hwdata}/share/hwdata/
    '';
  };

<<<<<<< HEAD
  wlroots = wlroots_0_16;
=======
  wlroots = wlroots_0_15;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
