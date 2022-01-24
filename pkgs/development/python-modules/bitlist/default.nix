{ lib
, buildPythonPackage
, fetchPypi
, nose
, parts
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bitlist";
  version = "0.6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69cf632ca61b5fb5d2fd7587ddf023bcab8f327302f15070ec9079b68df9082a";
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
