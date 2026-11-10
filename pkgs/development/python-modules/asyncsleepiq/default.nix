{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asyncsleepiq";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W/nUccq7SLgxz8WEFlPYXCaHy9F0GLjXq7KNt2kpe1k=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "asyncsleepiq" ];

  meta = {
    description = "Async interface to SleepIQ API";
    homepage = "https://github.com/kbickar/asyncsleepiq";
    changelog = "https://github.com/kbickar/asyncsleepiq/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
