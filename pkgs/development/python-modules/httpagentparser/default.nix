{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, tox
}:

buildPythonPackage rec {
  pname = "httpagentparser";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73Y9MZk912GCWs7myLNL4yuVzxZ10cc8PNNfnlKDGyY=";
  };

  checkInputs = [
    tox
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/httpagentparser/";
    description = "Extracts OS Browser etc information from http user agent string";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
