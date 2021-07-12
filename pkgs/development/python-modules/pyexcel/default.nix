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
  version = "0.6.6";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "39b0bb8f033d9b5523b126cf5a5259d1990ea82b8a23c8eab7aa5e23116803df";
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
