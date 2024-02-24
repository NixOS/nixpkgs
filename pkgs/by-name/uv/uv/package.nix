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
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    rev = version;
    hash = "sha256-N9m0dvJXABAY7dFTE5i7KXIHF9AMEFptEwKFoBsxmyE=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async_zip-0.0.16" = "sha256-M94ceTCtyQc1AtPXYrVGplShQhItqZZa/x5qLiL+gs0=";
      "pubgrub-0.2.1" = "sha256-p6RQ0pmatTnwp1s37ZktkhwakPTTehMlI3H5JUzwVrI=";
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
