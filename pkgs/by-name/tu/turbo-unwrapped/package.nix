{
  lib,
  stdenv,
  capnproto,
  extra-cmake-modules,
  fetchFromGitHub,
  fontconfig,
  llvmPackages,
  nix-update-script,
  openssl,
  pkg-config,
  protobuf,
  rust-jemalloc-sys,
  rustPlatform,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "turbo-unwrapped";
  version = "2.4.5-canary.4";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turborepo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tQ/Xocpk48eRhCyfRZx2rkAVqNn115rO3MRYF5fC2nI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pngzlmkntTCv5/aw1UNbDGNQOVtMgFZHc2woj6R0vys=";

  nativeBuildInputs =
    [
      capnproto
      extra-cmake-modules
      pkg-config
      protobuf
    ]
    # https://github.com/vercel/turbo/blob/ea740706e0592b3906ab34c7cfa1768daafc2a84/CONTRIBUTING.md#linux-dependencies
    ++ lib.optional stdenv.hostPlatform.isLinux llvmPackages.bintools;

  buildInputs = [
    fontconfig
    openssl
    rust-jemalloc-sys
    zlib
  ];

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
        "v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://turbo.build/";
    changelog = "https://github.com/vercel/turborepo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dlip
      getchoo
    ];
    mainProgram = "turbo";
  };
})
