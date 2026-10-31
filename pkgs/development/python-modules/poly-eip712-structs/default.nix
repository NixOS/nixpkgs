{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  eth-utils,
  pycryptodome,
}:

buildPythonPackage rec {
  pname = "poly-eip712-structs";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Polymarket";
    repo = "poly-py-eip712-structs";
    tag = "v${version}";
    hash = "sha256-9S23W3V/XSez8g3ncpdUZBV9yYd7mtImPiNKyruUWm4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    eth-utils
    pycryptodome
  ];

  # pytest is incorrectly listed as a runtime dependency upstream
  pythonRemoveDeps = [ "pytest" ];

  # Tests require network access
  doCheck = false;

  # Import check disabled: eth-utils imports pydantic at runtime but
  # nixpkgs has it as a check-only dependency
  pythonImportsCheck = [ ];

  meta = {
    description = "Python library for EIP-712 struct encoding (Polymarket fork)";
    homepage = "https://github.com/Polymarket/poly-py-eip712-structs";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
