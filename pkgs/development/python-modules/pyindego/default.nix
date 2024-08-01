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
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jm-73";
    repo = "pyIndego";
    rev = "refs/tags/${version}";
    hash = "sha256-wPQocacWwWjEH4boMZ33aW/NPvdD6LSmMTFXGwBwwq8=";
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
    homepage = "https://github.com/jm-73/pyIndego";
    changelog = "https://github.com/jm-73/pyIndego/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
