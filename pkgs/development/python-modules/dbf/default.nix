{ lib, fetchPypi, buildPythonPackage, aenum, isPy3k, pythonOlder, enum34, python }:

buildPythonPackage rec {
    pname = "dbf";
    version = "0.99.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-aeutAP2y+bUmUOZ39TpXULP+egeBcjyDmtoCheGzw+0=";
    };

    propagatedBuildInputs = [ aenum ] ++ lib.optional (pythonOlder "3.4") enum34;

    doCheck = !isPy3k;
    # tests are not yet ported.
    # https://groups.google.com/forum/#!topic/python-dbase/96rx2xmCG4w

    checkPhase = ''
      ${python.interpreter} dbf/test.py
    '';

    meta = with lib; {
      description = "Pure python package for reading/writing dBase, FoxPro, and Visual FoxPro .dbf files";
      homepage    = "https://pypi.python.org/pypi/dbf";
      license     = licenses.bsd2;
      maintainers = with maintainers; [ vrthra ];
    };
}
