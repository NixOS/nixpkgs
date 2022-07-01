{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "nulltype";
  version = "2.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0wpjbsmm0c9ifg9y6cnfz49qq9pa5f99nnqp6wdlv42ymfr3rak4";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nulltype"
  ];

  meta = with lib; {
    description = "Python library to handle Null values and sentinels like (but not) None, False and True";
    homepage = "https://pypi.org/project/nulltype/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
