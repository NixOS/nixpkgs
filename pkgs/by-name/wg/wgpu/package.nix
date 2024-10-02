{
  rustPlatform,
  lib,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  fontconfig,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "wgpu";
  version = "22.1.0";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu";
    rev = "refs/tags/wgpu-v${version}";
    hash = "sha256-Gtq0xYZoWNwW+BKVLqVVKGqc+4HjaD7NN1hlzyFP5g0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "noise-0.8.2" = "sha256-7GvShJeSNfwMCBIfqLghXgKQv7EDMqVchJw0uxPhNr4=";
      "rspirv-0.11.0+sdk-1.2.198" = "sha256-AcJqkcXBr/+SHdUDXd63sQ0h5eosMqRhV4aUREJH8Bw=";
    };
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      fontconfig
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        CoreServices
        QuartzCore
        AppKit
      ]
    );

  #requires GPU
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://wgpu.rs/";
    description = "Cross-platform, safe, pure-Rust graphics API.";
    changelog = "https://github.com/gfx-rs/wgpu/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = with lib.licenses; [
      mit
      apsl20
    ];
  };
}
