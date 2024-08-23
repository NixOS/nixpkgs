{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  darwin,
  fetchFromGitHub,
  libiconv,
  pythonOlder,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "ruff-api";
  version = "0.0.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amyreese";
    repo = "ruff-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-BW/qXq4HemqxhvjIKrrn07eqGJwAbYei7e+I+oHxujU=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "lsp-types-0.95.1" = "sha256-8Oh299exWXVi6A39pALOISNfp8XBya8z+KT/Z7suRxQ=";
      "ruff-0.4.10" = "sha256-FRBuvXtnbxRWoI0f8SM0U0Z5TRyX5Tbgq3d34Oh2bG4=";
    };
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
    libiconv
  ];

  # Tests have issues at the moment, check with next update
  doCheck = false;

  pythonImportsCheck = [ "ruff_api" ];

  meta = with lib; {
    description = "Experimental Python API for Ruff";
    homepage = "https://github.com/amyreese/ruff-api";
    changelog = "https://github.com/amyreese/ruff-api/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
