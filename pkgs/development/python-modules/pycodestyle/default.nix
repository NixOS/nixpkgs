{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v4prb05n21bm8650v0a01k1nyqjdmkrsm3zycfxh2j5k9n962p4";
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
    homepage = https://pycodestyle.readthedocs.io;
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
