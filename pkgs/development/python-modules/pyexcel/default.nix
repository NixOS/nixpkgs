{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, chardet
, lml
, pyexcel-io
, texttable
}:

buildPythonPackage rec {
  pname = "pyexcel";
  version = "0.6.7";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbbd9875729767564b3b64b6ed6a9870b14631184943d13646833d94157dd10f";
  };

  propagatedBuildInputs = [
    chardet
    lml
    pyexcel-io
    texttable
  ];

  pythonImportsCheck = [
    "pyexcel"
  ];

  # Tests depend on pyexcel-xls & co. causing circular dependency.
  # https://github.com/pyexcel/pyexcel/blob/dev/tests/requirements.txt
  doCheck = false;

  meta = {
    description = "Single API for reading, manipulating and writing data in csv, ods, xls, xlsx and xlsm files";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}
