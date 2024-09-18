{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  aiohttp,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytomorrowio";
  version = "0.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZCA+GYuZuRgc4Pi9Bcg4zthOnkmQ+/IddFMkR0WYfKk=";
  };

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytomorrowio" ];

  meta = {
    description = "Async Python package to access the Tomorrow.io API";
    homepage = "https://github.com/raman325/pytomorrowio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
