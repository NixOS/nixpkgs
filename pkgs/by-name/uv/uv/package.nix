{ lib
, cmake
, darwin
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "uv";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    rev = version;
    hash = "sha256-MPDzuk6pE+uKr9ic0Q9gIk1yByZ/FdcVZx6ZheECR8A=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async_zip-0.0.16" = "sha256-M94ceTCtyQc1AtPXYrVGplShQhItqZZa/x5qLiL+gs0=";
      "pubgrub-0.2.1" = "sha256-p6RQ0pmatTnwp1s37ZktkhwakPTTehMlI3H5JUzwVrI=";
    };
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  cargoBuildFlags = [ "--package" "uv" ];

  # Tests require network access
  doCheck = false;

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "An extremely fast Python package installer and resolver, written in Rust";
    homepage = "https://github.com/astral-sh/uv";
    changelog = "https://github.com/astral-sh/uv/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ marsam ];
    mainProgram = "uv";
  };
}
