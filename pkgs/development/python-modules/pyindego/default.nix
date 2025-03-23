{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "3.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sander1988";
    repo = "pyIndego";
    tag = version;
    hash = "sha256-x8/MSbn+urmArQCyxZU1JEUyATJsPzp7bflymE+1rkk=";
  };

  postPatch = ''
    sed -i "/addopts/d" pytest.ini
  '';

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
    homepage = "https://github.com/sander1988/pyIndego";
    changelog = "https://github.com/sander1988/pyIndego/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
