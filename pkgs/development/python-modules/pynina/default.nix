{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynina";
  version = "0.1.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyNINA";
    inherit version;
    sha256 = "sha256-U8/SzkkZJLRBpTQx8NRpFWUlckn4Jr0n9cHR4/plyb0=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
