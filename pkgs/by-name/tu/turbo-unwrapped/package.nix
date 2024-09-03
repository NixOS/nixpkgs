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
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    hash = "sha256-rh9BX8M3Kgu07Pz4G3AM6S9zeK3Bb6CzOpcYo7rQgIw=";
  };

  patches = [
    # upstream uses nightly where lazy_cell is stable
    ./enable-lazy_cell.patch
  ];

  cargoHash = "sha256-oZHSoPrPCUwXSrxEASm4LuYO+XHyNDRRl38Q7U7F/lk=";

  nativeBuildInputs =
    [
      capnproto
      extra-cmake-modules
      pkg-config
      protobuf
    ]
    # https://github.com/vercel/turbo/blob/ea740706e0592b3906ab34c7cfa1768daafc2a84/CONTRIBUTING.md#linux-dependencies
    ++ lib.optional stdenv.isLinux llvmPackages.bintools;

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
