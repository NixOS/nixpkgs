{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynina";
  version = "0.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyNINA";
    inherit version;
    hash = "sha256-6HJ78tKl6If/ezwOrGl3VEYO4eMh/6cZq2j2AMBr0I8=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pynina"
  ];

  meta = with lib; {
    description = "Python API wrapper to retrieve warnings from the german NINA app";
    homepage = "https://gitlab.com/DeerMaximum/pynina";
    changelog = "https://gitlab.com/DeerMaximum/pynina/-/releases/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
