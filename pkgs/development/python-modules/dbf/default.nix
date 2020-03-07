{ stdenv, fetchPypi, buildPythonPackage, aenum, isPy3k, pythonOlder, enum34, python }:

buildPythonPackage rec {
    pname = "dbf";
    version = "0.98.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "01d71vya2x87f3kl9x0s8xp0n7wixn6ksrd054y7idq3n1mjaxzh";
    };

    propagatedBuildInputs = [ aenum ] ++ stdenv.lib.optional (pythonOlder "3.4") enum34;

    doCheck = !isPy3k;
    # tests are not yet ported.
    # https://groups.google.com/forum/#!topic/python-dbase/96rx2xmCG4w

    checkPhase = ''
      ${python.interpreter} dbf/test.py
    '';

    meta = with stdenv.lib; {
      description = "Pure python package for reading/writing dBase, FoxPro, and Visual FoxPro .dbf files";
      homepage    = "https://pypi.python.org/pypi/dbf";
      license     = licenses.bsd2;
      maintainers = with maintainers; [ vrthra ];
    };
}
