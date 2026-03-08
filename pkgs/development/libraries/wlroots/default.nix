{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  libGL,
  wayland,
  wayland-protocols,
  libinput,
  libxkbcommon,
  pixman,
  libcap,
  libgbm,
  libxcb-wm,
  libxcb-render-util,
  libxcb-image,
  libxcb-errors,
  libx11,
  hwdata,
  seatd,
  vulkan-loader,
  glslang,
  libliftoff,
  libdisplay-info,
  lcms2,
  evdev-proto,
  nixosTests,
  testers,

  enableXWayland ? true,
  xwayland ? null,
}:

let
  generic =
    {
      version,
      hash,
      extraBuildInputs ? [ ],
      extraNativeBuildInputs ? [ ],
      patches ? [ ],
      postPatch ? "",
    }:
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
      outputs = [
        "out"
        "examples"
      ];

      strictDeps = true;
      depsBuildBuild = [ pkg-config ];

      nativeBuildInputs = [
        meson
        ninja
        pkg-config
        wayland-scanner
        glslang
        hwdata
      ]
      ++ extraNativeBuildInputs;

      propagatedBuildInputs = [
        # The headers of wlroots #include <libinput.h>, and consumers of `wlroots` need not add it explicitly, hence we propagate it.
        libinput
      ];

      buildInputs = [
        libliftoff
        libdisplay-info
        libGL
        libxkbcommon
        libgbm
        pixman
        seatd
        vulkan-loader
        wayland
        wayland-protocols
        libx11
        libxcb-errors
        libxcb-image
        libxcb-render-util
        libxcb-wm
        lcms2
      ]
      ++ lib.optional stdenv.hostPlatform.isLinux libcap
      ++ lib.optional stdenv.hostPlatform.isFreeBSD evdev-proto
      ++ lib.optional finalAttrs.enableXWayland xwayland
      ++ extraBuildInputs;

      mesonFlags = [
        (lib.mesonEnable "xwayland" finalAttrs.enableXWayland)
      ]
      # The other allocator, udmabuf, is a linux-specific API
      ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
        (lib.mesonOption "allocators" "gbm")
      ];

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
      passthru.tests = {
        tinywl = nixosTests.tinywl;
        pkg-config = testers.hasPkgConfigModules {
          package = finalAttrs.finalPackage;
        };
      };

      meta = {
        description = "Modular Wayland compositor library";
        longDescription = ''
          Pluggable, composable, unopinionated modules for building a Wayland
          compositor; or about 50,000 lines of code you were going to write anyway.
        '';
        inherit (finalAttrs.src.meta) homepage;
        changelog = "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${version}";
        license = lib.licenses.mit;
        platforms = lib.platforms.linux ++ lib.platforms.freebsd;
        maintainers = with lib.maintainers; [
          synthetica
          wineee
          doronbehar
        ];
        pkgConfigModules = [
          (
            if lib.versionOlder finalAttrs.version "0.18" then
              "wlroots"
            else
              "wlroots-${lib.versions.majorMinor finalAttrs.version}"
          )
        ];
      };
    });

in
{
  wlroots_0_18 = generic {
    version = "0.18.3";
    hash = "sha256-D8RapSeH+5JpTtq+OU8PyVZubLhjcebbCBPuSO5Q7kU=";
  };

  wlroots_0_19 = generic {
    version = "0.19.2";
    hash = "sha256-8VOhSaH9D0GkqyIP42W3uGcDT5ixPVDMT/OLlMXBNXA=";
  };
}
