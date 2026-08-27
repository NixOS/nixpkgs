{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  eth-utils,
  eth-account,
  poly-eip712-structs,
}:

buildPythonPackage rec {
  pname = "py-order-utils";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Polymarket";
    repo = "python-order-utils";
    tag = "v${version}";
    hash = "sha256-ZVlBf6stZQce92A2Pc6FUrPGtfOrGRQ18lVyW39QeNE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    eth-utils
    eth-account
    poly-eip712-structs
  ];

  # pytest is incorrectly listed as a runtime dependency upstream
  pythonRemoveDeps = [ "pytest" ];

  # Tests require network access
  doCheck = false;

  # Import check disabled: eth-utils imports pydantic at runtime but
  # nixpkgs has it as a check-only dependency
  pythonImportsCheck = [ ];

  meta = {
    description = "Utilities for building and signing Polymarket orders";
    homepage = "https://github.com/Polymarket/python-order-utils";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
