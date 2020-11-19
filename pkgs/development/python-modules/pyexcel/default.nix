{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, lml
, pyexcel-io
, texttable
, nose
}:

buildPythonPackage rec {
  pname = "pyexcel";
  version = "0.6.5";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "36588573ccb1c86e1a8869e1e9f6b31975a38c13803f015a197c18efd2e685ad";
  };

  propagatedBuildInputs = [
    lml
    pyexcel-io
    texttable
  ];

  checkInputs = [
    nose
  ];

  # Tests depend on pyexcel-xls & co. causing circular dependency.
  # https://github.com/pyexcel/pyexcel/blob/dev/tests/requirements.txt
  doCheck = false;

  pythonImportsCheck = [ "pyexcel" ];

  checkPhase = "nosetests";

  meta = {
    description = "Single API for reading, manipulating and writing data in csv, ods, xls, xlsx and xlsm files";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}
