{ lib, buildPythonPackage, fetchPypi, python3Packages, numpy, httpx, grpcio, typing-extensions, grpcio-tools, pydantic, urllib3, h2 }:

buildPythonPackage rec {
  pname = "qdrant-client";
  version = "1.1.0";

  src = fetchPypi {
    pname = "qdrant_client";
    inherit version;
    hash = "sha256-tiWPQXjYkUM77rgKYbQG4jdi9c/I2WTMq5y+9zLax/0=";
  };

  format = "pyproject";

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];


  # postPatch = ''
  #   substituteInPlace setup.cfg \
  #     --replace "validators>=0.18.2,<0.20.0" "validators>=0.18.2,<0.21.0"
  # '';

  propagatedBuildInputs = [ numpy httpx grpcio typing-extensions grpcio-tools pydantic urllib3 h2 ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/qdrant/qdrant-client";
    description = "Python client for Qdrant vector search engine";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
