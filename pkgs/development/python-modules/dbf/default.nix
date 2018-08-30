{ stdenv, fetchPypi, buildPythonPackage, aenum, isPy3k, pythonOlder, enum34, python }:

buildPythonPackage rec {
    pname = "dbf";
    version = "0.97.11";

    src = fetchPypi {
      inherit pname version;
      sha256 = "8aa5a73d8b140aa3c511a3b5b204a67d391962e90c66b380dd048fcae6ddbb68";
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
