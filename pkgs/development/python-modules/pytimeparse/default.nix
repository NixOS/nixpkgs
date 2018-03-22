{ stdenv, fetchPypi, buildPythonPackage, nose }:

buildPythonPackage rec {
    pname = "pytimeparse";
    version = "1.1.7";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "51b641bcd435e0cb6b9701ed79cf7ee97fa6bf2dbb5d41baa16e5486e5d9b17a";
    };

    propagatedBuildInputs = [ nose ];

    meta = with stdenv.lib; {
      description = "A small Python library to parse various kinds of time expressions";
      homepage    = "https://github.com/wroberts/pytimeparse";
      license     = licenses.mit;
      maintainers = with maintainers; [ vrthra ];
    };
}
