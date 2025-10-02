{
  lib,
  stdenv,
  buildGoModule,
  fetchzip,
  gst_all_1,
  gtkmm3,
  hidapi,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  python3,
  udev,
  udevCheckHook,
  wrapGAppsHook3,
}:

let
  version = "0.3.0";

  src = fetchzip {
    url = "https://github.com/carrotIndustries/usbkvm/releases/download/v${version}/usbkvm-v${version}.tar.gz";
    hash = "sha256-urexPODXU69QfSRHtJVpoDx/6mbPcv6EQ3mR0VRHNiY=";
  };

  ms-tools-lib = buildGoModule {
    pname = "usbkvm-ms-tools-lib";
    inherit version src;

    sourceRoot = "${src.name}/ms-tools";

    vendorHash = null; # dependencies are vendored in the release tarball

    buildInputs = [ hidapi ];

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/
      go build -C lib/ -o $out/ -buildmode=c-archive mslib.go

      runHook postBuild
    '';

    meta = {
      homepage = "https://github.com/carrotIndustries/ms-tools";
      description = "Program, library and reference designs to develop for MacroSilicon MS2106/MS2109/MS2130 chips";
      license = lib.licenses.mit;
    };
  };
in
stdenv.mkDerivation {
  pname = "usbkvm";
  inherit version src;

  # The package includes instructions to build the "mslib.{a,h}" files using a
  # Go compiler, but that doesn't work in the Nix sandbox. We patch out this
  # build step to instead copy those files from the Nix store:
  patches = [
    ./precompiled-mslib.patch
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "@MSLIB_A_PRECOMPILED@" "${ms-tools-lib}/mslib.a" \
      --replace-fail "@MSLIB_H_PRECOMPILED@" "${ms-tools-lib}/mslib.h"
  '';

  nativeBuildInputs = [
    pkg-config
    python3
    meson
    ninja
    makeWrapper
    wrapGAppsHook3
    udev
    udevCheckHook
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gtkmm3
    hidapi
  ];

  # Install udev rules in this package's out path:
  mesonFlags = [
    "-Dudevrulesdir=lib/udev/rules.d"
  ];

  postFixup =
    let
      GST_PLUGIN_PATH = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
        gst_all_1.gst-plugins-base
        (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
      ];
    in
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/usbkvm \
        --prefix GST_PLUGIN_PATH : "${GST_PLUGIN_PATH}"
    '';

  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/carrotIndustries/usbkvm";
    description = "Open-source USB KVM (Keyboard, Video and Mouse) adapter";
    changelog = "https://github.com/carrotIndustries/usbkvm/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lschuermann ];
    mainProgram = "usbkvm";
  };
}
