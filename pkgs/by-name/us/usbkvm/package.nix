{
  buildGoModule,
  fetchzip,
  gst_all_1,
  gtkmm3,
  hidapi,
  lib,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  python3,
  stdenv,
  wrapGAppsHook3,
}:

let
  version = "0.1.0";

  src = fetchzip {
    url = "https://github.com/carrotIndustries/usbkvm/releases/download/v${version}/usbkvm-v${version}.tar.gz";
    sha256 = "sha256-OuZ7+IjsvK7/PaiTRwssaQFJDFWJ8HX+kqV13CUyTZA=";
  };

  ms-tools-lib = buildGoModule {
    pname = "usbkvm-ms-tools-lib";
    inherit version;

    inherit src;
    sourceRoot = "source/ms-tools";
    vendorHash = null; # dependencies are vendored in the release tarball

    buildInputs = [
      hidapi
    ];

    buildPhase = ''
      mkdir -p $out/
      go build -C lib/ -o $out/ -buildmode=c-archive mslib.go
    '';
  };
in
stdenv.mkDerivation {
  pname = "usbkvm";
  inherit version src;

  nativeBuildInputs = [
    pkg-config
    python3
    meson
    ninja
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gtkmm3
    hidapi
  ];

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

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d/
    cp ../70-usbkvm.rules $out/lib/udev/rules.d/
  '';

  meta = {
    homepage = "https://github.com/carrotIndustries/usbkvm";
    description = "An open-source USB KVM (Keyboard, Video and Mouse) adapter";
    changelog = "https://github.com/carrotIndustries/usbkvm/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ lschuermann ];
    mainProgram = "usbkvm";
  };
}
