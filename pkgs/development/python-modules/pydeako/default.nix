{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "pydeako";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "DeakoLights";
    repo = "pydeako";
    tag = version;
    hash = "sha256-GEYuVKE3DOXJzCqTW2Ngoi6l0e4JvE9lUnZtjrNXTVk=";
  };

  build-system = [ setuptools ];

  dependencies = [ zeroconf ];

  # Module has no tests
  #doCheck = false;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydeako" ];

  meta = {
    description = "Module used to discover and communicate with Deako devices over the network locally";
    homepage = "https://github.com/DeakoLights/pydeako";
    changelog = "https://github.com/DeakoLights/pydeako/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
