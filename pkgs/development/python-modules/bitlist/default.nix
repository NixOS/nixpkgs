{ lib
, buildPythonPackage
, fetchPypi
, nose
, parts
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bitlist";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LTrn+PCaqob0EGyyv1V1uCBeDQZvIYE1hNPqi4y/zfc=";
  };

  propagatedBuildInputs = [
    parts
  ];

  checkInputs = [
    pytestCheckHook
    nose
  ];

  pythonImportsCheck = [
    "bitlist"
  ];

  meta = with lib; {
    description = "Python library for working with little-endian list representation of bit strings";
    homepage = "https://github.com/lapets/bitlist";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
