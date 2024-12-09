{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  versionCheckHook,
  nix-update-script,
  # Runtime deps:
  alsa-lib,
  udev,
  libGL,
  vulkan-headers,
  vulkan-loader,
}:
rustPlatform.buildRustPackage rec {
  pname = "ttysvr";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "cxreiff";
    repo = "ttysvr";
    rev = "refs/tags/v${version}";
    hash = "sha256-qUwnx+hwd3PRzz1TlQzPAppj6aTZZpTG2e5cBaA3zZI=";
  };
  cargoHash = "sha256-kIE8+FUS3i8Ulkj35lO1iRmFx5x+r89THVuzNzAv6tE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    udev
    libGL
    vulkan-headers
    vulkan-loader
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/ttysvr \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          vulkan-loader
        ]
      }
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Screen saver for your terminal";
    homepage = "https://github.com/cxreiff/ttysvr";
    changelog = "https://github.com/cxreiff/ttysvr/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ griffi-gh ];
    mainProgram = "ttysvr";
    platforms = with lib.platforms; linux;
  };
}
