{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c58a7d2815e0e8d7972bf1803331fb0152f867bd89adf8a01dfd55085434192e";
  };

  # https://github.com/PyCQA/pycodestyle/blob/2.5.0/tox.ini#L14
  checkPhase = ''
    python pycodestyle.py --max-doc-length=72 --testsuite testsuite
    python pycodestyle.py --statistics pycodestyle.py
    python pycodestyle.py --max-doc-length=72 --doctest
    python setup.py test
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
