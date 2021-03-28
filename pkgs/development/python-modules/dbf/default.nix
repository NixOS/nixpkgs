{ lib, fetchPypi, buildPythonPackage, aenum, isPy3k, pythonOlder, enum34, python }:

buildPythonPackage rec {
    pname = "dbf";
    version = "0.99.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "4ed598a3866dfe7761b8099cf53ab44cb6ed5e4a7dbffb0da8c67a4af8d62fc5";
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
