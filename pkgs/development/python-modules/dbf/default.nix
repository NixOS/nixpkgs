{ stdenv, fetchPypi, buildPythonPackage, aenum, isPy3k, pythonOlder, enum34, python }:

buildPythonPackage rec {
    pname = "dbf";
    version = "0.97.7";

    src = fetchPypi {
      inherit pname version;
      sha256 = "855800d12df87855096eeafc58f34c9092407e8faf197f48073e7bc2b1938de0";
    };

    propagatedBuildInputs = [ aenum ] ++ stdenv.lib.optional (pythonOlder "3.4") [ enum34 ];

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
