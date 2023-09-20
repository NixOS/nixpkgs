{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "hkavr";
  version = "0.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wa0yS0KPdrQUuxxViweESD6Itn2rFlTwwrPQ0COWIPc=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "hkavr"
  ];

  meta = with lib; {
    description = "Library for interacting with Harman Kardon AVR controllers";
    homepage = "https://github.com/Devqon/hkavr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
