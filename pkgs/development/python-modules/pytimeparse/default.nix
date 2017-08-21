{ stdenv, fetchPypi, buildPythonPackage, nose }:

buildPythonPackage rec {
    pname = "pytimeparse";
    version = "1.1.6";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0imbb68i5n5fm704gv47if1blpxd4f8g16qmp5ar07cavgh2mibl";
    };

    propagatedBuildInputs = [ nose ];

    meta = with stdenv.lib; {
      description = "A small Python library to parse various kinds of time expressions";
      homepage    = "https://github.com/wroberts/pytimeparse";
      license     = licenses.mit;
      maintainers = with maintainers; [ vrthra ];
    };
}
