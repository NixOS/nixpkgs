{ stdenv, fetchPypi, buildPythonPackage, aenum, isPy3k }:

buildPythonPackage rec {
    pname = "dbf";
    version = "0.96.8";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1z8n7s4cka6x9ybh4qpfhj51v2qrk38h2f06npizzhm0hmn6r3v1";
    };

    propagatedBuildInputs = [ aenum ];

    doCheck = !isPy3k;
    # tests are not yet ported.
    # https://groups.google.com/forum/#!topic/python-dbase/96rx2xmCG4w

    meta = with stdenv.lib; {
      description = "Pure python package for reading/writing dBase, FoxPro, and Visual FoxPro .dbf files";
      homepage    = "https://pypi.python.org/pypi/dbf";
      license     = licenses.bsd2;
      maintainers = with maintainers; [ vrthra ];
    };
}
