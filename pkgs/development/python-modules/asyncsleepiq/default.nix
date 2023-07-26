{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncsleepiq";
  version = "1.3.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nKXZXOpwVN8Xe1vwwPGPucvyffiIQ8I4D+0A3qGco5w=";
  };

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
