{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "asyncsleepiq";
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YZimENglXCamHWGS3TrLNsaRMa/deNJiQ1fs8KAj7rc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "asyncsleepiq"
  ];

  meta = with lib; {
    description = "Async interface to SleepIQ API";
    homepage = "https://github.com/kbickar/asyncsleepiq";
    changelog = "https://github.com/kbickar/asyncsleepiq/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
