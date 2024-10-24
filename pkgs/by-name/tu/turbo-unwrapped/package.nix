{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  capnproto,
  darwin,
  extra-cmake-modules,
  fontconfig,
  llvmPackages,
  nix-update-script,
  openssl,
  pkg-config,
  protobuf,
  rust-jemalloc-sys,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "turbo-unwrapped";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "refs/tags/v${version}";
    hash = "sha256-MDvwitzZVPVjdIVEAV1aKMAVeLSTMM2owH5RSfVg+rU=";
  };

  cargoHash = "sha256-XBI/eiOyKk80ZDFLD2HCTFYRWvC7qtzQY/zFCmKdKSM=";

  nativeBuildInputs =
    [
      capnproto
      extra-cmake-modules
      pkg-config
      protobuf
    ]
    # https://github.com/vercel/turbo/blob/ea740706e0592b3906ab34c7cfa1768daafc2a84/CONTRIBUTING.md#linux-dependencies
    ++ lib.optional stdenv.hostPlatform.isLinux llvmPackages.bintools;

  buildInputs =
    [
      fontconfig
      openssl
      rust-jemalloc-sys
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk_11_0.frameworks;
      [
        CoreFoundation
        CoreServices
        IOKit
      ]
    );

  cargoBuildFlags = [
    "--package"
    "turbo"
  ];

  # Browser tests time out with chromium and google-chrome
  doCheck = false;

  env = {
    # nightly features are used
    RUSTC_BOOTSTRAP = 1;
  };

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "'v(\d+\.\d+\.\d+)'"
      ];
    };
  };

  meta = {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://turbo.build/";
    changelog = "https://github.com/vercel/turbo/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dlip
      getchoo
    ];
    mainProgram = "turbo";
  };
}
