{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  libiconv,
  pythonOlder,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "ruff-api";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amyreese";
    repo = "ruff-api";
    tag = "v${version}";
    hash = "sha256-1XULyxu3XujhAcFnvqI5zMiXOc0axx1LS4EevjhoGDc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-q8Y5oqoSzUk1Xg4AmjLs7RO8Kr87Oi3eKLSpmXlHp4U=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # Tests have issues at the moment, check with next update
  doCheck = false;

  pythonImportsCheck = [ "ruff_api" ];

  meta = {
    description = "Experimental Python API for Ruff";
    homepage = "https://github.com/amyreese/ruff-api";
    changelog = "https://github.com/amyreese/ruff-api/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
