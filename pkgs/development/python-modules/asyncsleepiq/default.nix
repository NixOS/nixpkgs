{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asyncsleepiq";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Fhs1vsAmuCKpkNr5paoY4JGoS8LQzkiZn+m5JWq6Hc0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "asyncsleepiq" ];

  meta = with lib; {
    description = "Async interface to SleepIQ API";
    homepage = "https://github.com/kbickar/asyncsleepiq";
    changelog = "https://github.com/kbickar/asyncsleepiq/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
