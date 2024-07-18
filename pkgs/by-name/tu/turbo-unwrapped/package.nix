{
  stdenv,
  lib,
  fetchFromGitHub,
  protobuf,
  rustPlatform,
  autoPatchelfHook,
  capnproto,
  darwin,
  extra-cmake-modules,
  fontconfig,
  lld,
  # see comment below
  # nix-update-script,
  openssl,
  pkg-config,
  rust-jemalloc-sys,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "turbo-unwrapped";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    hash = "sha256-N6tLRJGV1AuAUH3qm4y4DgYsWO7ItNDmBI+f/O2hWXw=";
  };

  patches = [
    # upstream uses nightly where lazy_cell is stable
    ./enable-lazy_cell.patch
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pathfinder_simd-0.5.3" = "sha256-94/qS5d0UKYXAdx+Lswj6clOTuuK2yxqWuhpYZ8x1nI=";
    };
  };

  nativeBuildInputs =
    [
      capnproto
      extra-cmake-modules
      pkg-config
      protobuf
    ]
    # https://github.com/vercel/turbo/blob/ea740706e0592b3906ab34c7cfa1768daafc2a84/CONTRIBUTING.md#linux-dependencies
    ++ lib.optional stdenv.isLinux lld
    ++ lib.optional stdenv.hostPlatform.isElf autoPatchelfHook;

  buildInputs =
    [
      fontconfig
      openssl
      rust-jemalloc-sys
      zlib
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
    # nightly features are used
    RUSTC_BOOTSTRAP = 1;
  };

  passthru = {
    # TODO: The repo's releases.atom doesn't seem to have any stable releases? This breaks updating for now :/
    # updateScript = nix-update-script { };
  };

  meta = {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://turbo.build/";
    changelog = "https://github.com/vercel/turbo/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      dlip
      getchoo
    ];
    mainProgram = "turbo";
  };
}
