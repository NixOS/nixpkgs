{ buildPythonPackage, fetchPypi, lib, python }:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zxyrg8029lzjhima6l5nk6y0z6lm5wfp9qchz3s33j3xx3mipgd";
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
    maintainers = with maintainers; [ kamadorueda ];
  };
}
