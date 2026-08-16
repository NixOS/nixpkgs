{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wlroots_0_19,
  wlroots_0_20,
  scdoc,
  pkg-config,
  wayland,
  libdrm,
  libxkbcommon,
  pixman,
  wayland-protocols,
  libGL,
  libgbm,
  libxcb,
  libxcb-wm,
  lcms2,
  validatePkgConfig,
  testers,
  wayland-scanner,
}:

let
  generic =
    {
      version,
      hash,
      wlroots,
      extraBuildInputs ? [ ],
    }:
    stdenv.mkDerivation (finalAttrs: {
      __structuredAttrs = true;
      pname = "scenefx";
      inherit version;

      src = fetchFromGitHub {
        owner = "wlrfx";
        repo = "scenefx";
        tag = finalAttrs.version;
        inherit hash;
      };

      strictDeps = true;
      depsBuildBuild = [ pkg-config ];

      nativeBuildInputs = [
        meson
        ninja
        pkg-config
        scdoc
        validatePkgConfig
        wayland-scanner
      ];

      buildInputs = [
        libdrm
        libGL
        libxkbcommon
        libgbm
        libxcb
        libxcb-wm
        pixman
        wayland
        wayland-protocols
        wlroots
      ]
      ++ extraBuildInputs;

      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

      meta = {
        description = "Drop-in replacement for the wlroots scene API that allows wayland compositors to render surfaces with eye-candy effects";
        homepage = "https://github.com/wlrfx/scenefx";
        changelog = "https://github.com/wlrfx/scenefx/releases/tag/${finalAttrs.version}";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [
          swarsel
          yvnth
        ];

        mainProgram = "scenefx";
        pkgConfigModules = [ "scenefx-${lib.versions.majorMinor finalAttrs.version}" ];
        platforms = lib.platforms.all;
      };
    });

in
rec {
  scenefx_0_4 = generic {
    version = "0.4.1";
    hash = "sha256-XD5EcquaHBg5spsN06fPHAjVCb1vOMM7oxmjZZ/PxIE=";
    wlroots = wlroots_0_19;
  };

  scenefx_0_5 = generic {
    version = "0.5";
    hash = "sha256-vUjLG6eubEhJJVa9LPygIcVmNoHwYbSUTJcWEcbxnU4=";
    wlroots = wlroots_0_20;
    extraBuildInputs = [ lcms2 ];
  };

  scenefx = scenefx_0_5;
}
