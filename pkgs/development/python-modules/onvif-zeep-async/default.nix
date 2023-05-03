{ lib
, buildPythonPackage
, fetchPypi
, httpx
, pythonOlder
, zeep
}:

buildPythonPackage rec {
  pname = "onvif-zeep-async";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Bh7QA86oL/CeRSLHdwvBdO39+AZwTqA7ZVERw1jvJtU=";
  };

  propagatedBuildInputs = [
    httpx
    zeep
  ];

  pythonImportsCheck = [
    "onvif"
  ];

  # Tests are not shipped
  doCheck = false;

  meta = with lib; {
    description = "ONVIF Client Implementation in Python";
    homepage = "https://github.com/hunterjm/python-onvif-zeep-async";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
