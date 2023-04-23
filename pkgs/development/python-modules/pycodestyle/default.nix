{ buildPythonPackage
, pythonOlder
, fetchPypi
, lib
, python
}:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.10.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NHGHvbR2Mp2Y9pXCE9cpWoRtEVL/T+m6y4qVkLjucFM=";
  };

  # https://github.com/PyCQA/pycodestyle/blob/2.10.0/tox.ini#L13
  checkPhase = ''
    ${python.interpreter} -m pycodestyle --statistics pycodestyle.py
    ${python.interpreter} -m pycodestyle --max-doc-length=72 --testsuite testsuite
    ${python.interpreter} -m pycodestyle --max-doc-length=72 --doctest
    ${python.interpreter} -m unittest discover testsuite -vv
  '';

  pythonImportsCheck = [ "pycodestyle" ];

  meta = with lib; {
    changelog = "https://github.com/PyCQA/pycodestyle/blob/${version}/CHANGES.txt";
    description = "Python style guide checker";
    homepage = "https://pycodestyle.pycqa.org/";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
