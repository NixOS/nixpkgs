{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mock,
  netaddr,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyeapi";
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arista-eosplus";
    repo = "pyeapi";
    tag = "v${version}";
    hash = "sha256-eGNBQSnYMC9YVCw5mBRH6XRq139AcqFm6HnO2FUzLEE=";
  };

  build-system = [ setuptools ];

  dependencies = [ netaddr ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  enabledTestPaths = [ "test/unit" ];

  pythonImportsCheck = [ "pyeapi" ];

  meta = with lib; {
    description = "Client for Arista eAPI";
    homepage = "https://github.com/arista-eosplus/pyeapi";
    changelog = "https://github.com/arista-eosplus/pyeapi/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ astro ];
  };
}
