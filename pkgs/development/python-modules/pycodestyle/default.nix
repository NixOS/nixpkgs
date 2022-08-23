{ buildPythonPackage
, pythonOlder
, fetchPypi
, lib
, python
}:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.9.1";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c9607871d58c76354b697b42f5d57e1ada7d261c261efac224b664affdc5785";
  };

  # https://github.com/PyCQA/pycodestyle/blob/2.9.1/tox.ini#L13
  checkPhase = ''
    ${python.interpreter} -m pycodestyle --statistics pycodestyle.py
    ${python.interpreter} -m pycodestyle --max-doc-length=72 --testsuite testsuite
    ${python.interpreter} -m pycodestyle --max-doc-length=72 --doctest
    ${python.interpreter} -m unittest discover testsuite -vv
  '';

  pythonImportsCheck = [ "pycodestyle" ];

  meta = with lib; {
    description = "Python style guide checker";
    homepage = "https://pycodestyle.pycqa.org/";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
