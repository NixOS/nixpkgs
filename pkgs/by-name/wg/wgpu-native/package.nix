{
  rustPlatform,
  llvmPackages,
  lib,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  glfw,
  meson,
  pkg-config,
  fontconfig,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "wgpu-native";
  version = "22.1.0.5";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu-native";
    rev = "refs/tags/v${version}";
    hash = "sha256-lEUHRU7+sFWtEYTOB2F+SmMNG8nrjro3IL7BgYuIGgM=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "d3d12-22.0.0" = "sha256-Gtq0xYZoWNwW+BKVLqVVKGqc+4HjaD7NN1hlzyFP5g0=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    glfw
  ];

  buildInputs =
    [ fontconfig ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        CoreServices
        QuartzCore
        AppKit
      ]
    );

  postInstall = ''
    install -Dm664 ./ffi/wgpu.h -t $out/include/webgpu
    install -Dm664 ./ffi/webgpu-headers/webgpu.h -t $out/include/webgpu
    install -Dm664 ./ffi/webgpu-headers/webgpu.yml -t $out/wgpu-native-meta
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://wgpu.rs/";
    description = "Native headers and library of the Rust WebGPU API";
    changelog = "https://github.com/gfx-rs/wgpu-native/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ sbancuz ];
    license = with lib.licenses; [
      mit
      asl20
    ];
  };
}
