{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  capnproto,
  darwin,
  extra-cmake-modules,
  fontconfig,
  nix-update-script,
  openssl,
  pkg-config,
  protobuf,
  rust-jemalloc-sys,
}:
rustPlatform.buildRustPackage rec {
  pname = "turbo-unwrapped";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    hash = "sha256-q1BxBAjfHyGDaH/IywPw9qnZJjzeU4tu2CyUWbnd6y8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes."tui-term-0.1.8" = "sha256-MNeVnF141uNWbjqXEbHwXnMTkCnvIteb5v40HpEK6D4=";
  };

  nativeBuildInputs = [
    capnproto
    extra-cmake-modules
    pkg-config
    protobuf
  ];

  buildInputs =
    [
      fontconfig
      openssl
      rust-jemalloc-sys
    ]
    ++ lib.optionals stdenv.isDarwin (
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
    # TODO: do we need this?
    # https://github.com/vercel/turbo/blob/8de0996c8fe310ff45c4583e9629abd9455bb350/.github/workflows/turborepo-release.yml#L18
    RELEASE_TURBO_CLI = "true";

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
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dlip ];
    mainProgram = "turbo";
  };
}
