{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "dbfread";
    version = "2.0.5";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0r5axq9ax0czyapm7b69krcv22r1nyb4vci7c5x8mx8pq1axim93";
    };

    meta = with stdenv.lib; {
      description = "Read DBF Files with Python";
      homepage    = http://dbfread.readthedocs.org/;
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ vrthra ];
    };
}
