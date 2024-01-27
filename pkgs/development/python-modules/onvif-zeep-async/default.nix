{ lib
, buildPythonPackage
, ciso8601
, fetchPypi
, httpx
, pythonOlder
, zeep
}:

buildPythonPackage rec {
  pname = "onvif-zeep-async";
  version = "3.1.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TXSwrWnDXzntXZN/u09QB3BsIa6tpf6LpGFKEyA/GH8=";
  };

  propagatedBuildInputs = [
    ciso8601
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
