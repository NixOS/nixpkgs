{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "fivem-api";
  version = "0.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6llrMGWbDRmysEw+B6B115hLS5xlktQEXiSHzPLbV5s=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "fivem"
  ];

  meta = with lib; {
    description = "Module for interacting with FiveM servers";
    homepage = "https://github.com/Sander0542/fivem-api";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
