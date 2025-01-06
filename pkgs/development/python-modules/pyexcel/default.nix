{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  chardet,
  lml,
  pyexcel-io,
  texttable,
}:

buildPythonPackage rec {
  pname = "pyexcel";
  version = "0.7.1";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yHWZHB3pAUBjRdE8fd5sSs/V8IsWr2xKiBpSxsPDqwY=";
  };

  propagatedBuildInputs = [
    chardet
    lml
    pyexcel-io
    texttable
  ];

  pythonImportsCheck = [ "pyexcel" ];

  # Tests depend on pyexcel-xls & co. causing circular dependency.
  # https://github.com/pyexcel/pyexcel/blob/dev/tests/requirements.txt
  doCheck = false;

  meta = {
    description = "Single API for reading, manipulating and writing data in csv, ods, xls, xlsx and xlsm files";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
