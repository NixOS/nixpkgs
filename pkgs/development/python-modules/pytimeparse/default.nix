{ lib, fetchPypi, buildPythonPackage, nose }:

buildPythonPackage rec {
    pname = "pytimeparse";
    version = "1.1.8";

    src = fetchPypi {
      inherit pname version;
      sha256 = "e86136477be924d7e670646a98561957e8ca7308d44841e21f5ddea757556a0a";
    };

    nativeCheckInputs = [ nose ];

    meta = with lib; {
      description = "A small Python library to parse various kinds of time expressions";
      homepage    = "https://github.com/wroberts/pytimeparse";
      license     = licenses.mit;
      maintainers = with maintainers; [ vrthra ];
    };
}
