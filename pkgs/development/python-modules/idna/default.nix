{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "idna";
  version = "3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3";
  };

  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}
