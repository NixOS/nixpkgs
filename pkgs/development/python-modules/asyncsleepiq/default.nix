{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asyncsleepiq";
  version = "1.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m0Is5X46pOGTu7TBBBY/sgC3GNxULYkONe5H1rCAnb0=";
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
