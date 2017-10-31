{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "dbfread";
    version = "2.0.7";

    src = fetchPypi {
      inherit pname version;
      sha256 = "07c8a9af06ffad3f6f03e8fe91ad7d2733e31a26d2b72c4dd4cfbae07ee3b73d";
    };

    meta = with stdenv.lib; {
      description = "Read DBF Files with Python";
      homepage    = http://dbfread.readthedocs.org/;
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ vrthra ];
    };
}
