{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  furl,
  hatchling,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "mvg";
  version = "1.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-jpk6DUaQYtL7OHDOznhgAp0N8qao0wQI5benfPXwhJI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    furl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # tests require network access
  doCheck = false;

  pythonImportsCheck = [ "mvg" ];

  meta = {
    description = "An unofficial interface to timetable information of the Münchner Verkehrsgesellschaft (MVG)";
    homepage = "https://github.com/mondbaron/mvg";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
