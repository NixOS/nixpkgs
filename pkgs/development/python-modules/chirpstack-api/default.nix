{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpcio
}:

buildPythonPackage rec {
  pname = "chirpstack-api";
  version = "3.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08djidy3fyhghyzvndcjas3hb1s9d7719gvmgbl8bzxjm4h2c433";
  };

  propagatedBuildInputs = [
    google-api-core
    grpcio
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "chirpstack_api" ];

  meta = with lib; {
    description = "ChirpStack gRPC API message and service wrappers for Python";
    homepage = "https://github.com/brocaar/chirpstack-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
