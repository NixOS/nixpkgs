{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  requests,
  pytz,

  # tests
  mock,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyindego";
  version = "3.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pyIndego";
    inherit version;
    hash = "sha256-lRDi6qYMaPI8SiSNe0vzlKb92axujt44aei8opNPDug=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
    pytz
  ];

  nativeCheckInputs = [
    mock
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Typeerror, presumably outdated tests
    "test_repr"
    "test_client_response_errors"
    "test_update_battery"
  ];

  pythonImportsCheck = [ "pyIndego" ];

  meta = with lib; {
    description = "Python interface for Bosch API for lawnmowers";
    homepage = "https://github.com/jm-73/pyIndego";
    changelog = "https://github.com/jm-73/pyIndego/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
