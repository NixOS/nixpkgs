{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  eth-account,
  eth-utils,
  poly-eip712-structs,
  py-order-utils,
  python-dotenv,
  requests,
}:

buildPythonPackage rec {
  pname = "py-clob-client";
  version = "0.17.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Polymarket";
    repo = "py-clob-client";
    tag = "v${version}";
    hash = "sha256-WDmUl38CU7mL0p+dWSFGGSHeBAccVi81LWBTpUvEkwQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    eth-account
    eth-utils
    poly-eip712-structs
    py-order-utils
    python-dotenv
    requests
  ];

  # Tests require API keys and network access
  doCheck = false;

  pythonImportsCheck = [ "py_clob_client" ];

  meta = {
    description = "Python client for the Polymarket CLOB API";
    homepage = "https://github.com/Polymarket/py-clob-client";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
