{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  darwin,
  fetchFromGitHub,
  pythonOlder,
  rustc,
  rustPlatform,
  ufmt,
  usort,
}:

buildPythonPackage rec {
  pname = "ruff-api";
  version = "0.0.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amyreese";
    repo = "ruff-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-nZKf0LpCoYwWoLDGoorJ+zQSLyuxfWu3LOygocVlYSs=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ruff-0.3.7" = "sha256-PS4YJpVut+KtEgSlTVtoVdlu6FVipPIzsl01/Io5N64=";
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
