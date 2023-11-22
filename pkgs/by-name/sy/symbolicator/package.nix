{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, openssl
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "symbolicator";
  version = "23.11.0";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolicator";
    rev = version;
    hash = "sha256-eXMMk12ZxRs5k3DaRhGADwLbE62L8e4N3R5Rw8kZMKI=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cpp_demangle-0.4.1" = "sha256-9QopX2TOJc8bZ+UlSOFdjoe8NTJLVGrykyFL732tE3A=";
      "reqwest-0.11.18" = "sha256-t6fs2bbBfgcspCrGfWIFCYbYZ7GPcBWI0dy68YdklOQ=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    openssl
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    SYMBOLICATOR_GIT_VERSION = src.rev;
    SYMBOLICATOR_RELEASE = version;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  } // lib.optionalAttrs stdenv.cc.isClang {
    # Work around https://github.com/NixOS/nixpkgs/issues/166205.
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Native Symbolication as a Service";
    homepage = "https://getsentry.github.io/symbolicator/";
    changelog = "https://github.com/getsentry/symbolicator/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "symbolicator";
  };
}
