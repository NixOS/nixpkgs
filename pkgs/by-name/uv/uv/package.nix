{ lib
, cargo
, cmake
, darwin
, fetchFromGitHub
, libgit2
, openssl
, pkg-config
, python3
, rustPlatform
, rustc
, stdenv
, zlib
}:

python3.pkgs.buildPythonApplication rec {
  pname = "uv";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    rev = version;
    hash = "sha256-ZrXWipg3m5T3PiUF7IgAxtw1GGnzVZTZdodFwNCu054=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async_zip-0.0.16" = "sha256-M94ceTCtyQc1AtPXYrVGplShQhItqZZa/x5qLiL+gs0=";
      "pubgrub-0.2.1" = "sha256-yCeUJp0Cy5Fe0g3Ba9ZFqTJ7IzSFqrX8Dv3+N8DAEZs=";
    };
  };

  nativeBuildInputs = [
    cargo
    cmake
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "uv" ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "An extremely fast Python package installer and resolver, written in Rust";
    homepage = "https://github.com/astral-sh/uv";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ marsam ];
    mainProgram = "uv";
  };
}
