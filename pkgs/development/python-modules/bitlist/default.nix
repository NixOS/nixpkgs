{ lib
, buildPythonPackage
, fetchPypi
, nose
, parts
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bitlist";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IL1tpP/F6O3BvJab6aC6r6PhRgKFpLp9aXmOK1rQXaU=";
  };

  propagatedBuildInputs = [
    parts
  ];

  checkInputs = [
    pytestCheckHook
    nose
  ];

  pythonImportsCheck = [ "bitlist" ];

  meta = with lib; {
    description = "Python library for working with little-endian list representation of bit strings";
    homepage = "https://github.com/lapets/bitlist";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
