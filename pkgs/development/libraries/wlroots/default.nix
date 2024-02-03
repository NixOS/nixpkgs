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

      postPatch = extraPatch;

      # $out for the library and $examples for the example programs (in examples):
      outputs = [ "out" "examples" ];

      strictDeps = true;
      depsBuildBuild = [ pkg-config ];

      nativeBuildInputs = [ meson ninja pkg-config wayland-scanner glslang ]
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

      meta = with lib; {
        description = "A modular Wayland compositor library";
        longDescription = ''
          Pluggable, composable, unopinionated modules for building a Wayland
          compositor; or about 50,000 lines of code you were going to write anyway.
        '';
        inherit (finalAttrs.src.meta) homepage;
        changelog = "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${version}";
        license = licenses.mit;
        platforms = platforms.linux;
        maintainers = with maintainers; [ primeos synthetica ];
      };
    });

in
rec {
  wlroots_0_15 = generic {
    version = "0.15.1";
    hash = "sha256-MFR38UuB/wW7J9ODDUOfgTzKLse0SSMIRYTpEaEdRwM=";
  };

  wlroots_0_16 = generic {
    version = "0.16.2";
    hash = "sha256-JeDDYinio14BOl6CbzAPnJDOnrk4vgGNMN++rcy2ItQ=";
    extraPatch = ''
      substituteInPlace backend/drm/meson.build \
        --replace /usr/share/hwdata/ ${hwdata}/share/hwdata/
    '';
  };

  wlroots = wlroots_0_16;
}
