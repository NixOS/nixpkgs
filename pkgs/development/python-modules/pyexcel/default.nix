{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, lml
, pyexcel-io
, texttable
, nose
}:

buildPythonPackage rec {
  pname = "pyexcel";
  version = "0.6.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "pPNYnimHhW7SL6X6OLwagZoadTD7IdUSbO7vAqQPQu8=";
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
