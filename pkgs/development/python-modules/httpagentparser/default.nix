{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "httpagentparser";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73Y9MZk912GCWs7myLNL4yuVzxZ10cc8PNNfnlKDGyY=";
  };

  # PyPi version does not include test directory
  doCheck = false;

  pythonImportsCheck = [ "httpagentparser" ];

  meta = with lib; {
    homepage = "https://github.com/shon/httpagentparser";
    description = "Extracts OS Browser etc information from http user agent string";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
