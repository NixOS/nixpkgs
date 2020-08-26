{ buildPythonPackage
, fetchPypi
, lib
, python
}:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c58a7d2815e0e8d7972bf1803331fb0152f867bd89adf8a01dfd55085434192e";
  };

  dontUseSetuptoolsCheck = true;

  # https://github.com/PyCQA/pycodestyle/blob/2.5.0/tox.ini#L14
  checkPhase = ''
    ${python.interpreter} pycodestyle.py --max-doc-length=72 --testsuite testsuite
    ${python.interpreter} pycodestyle.py --statistics pycodestyle.py
    ${python.interpreter} pycodestyle.py --max-doc-length=72 --doctest
    ${python.interpreter} -m unittest discover testsuite -vv
  '';

  meta = with lib; {
    description = "Python style guide checker (formerly called pep8)";
    homepage = "https://pycodestyle.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
