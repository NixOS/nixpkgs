{ lib
, buildPythonPackage
, fetchFromGitHub
, google-api-core
, grpcio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "chirpstack-api";
  version = "3.12.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "brocaar";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-69encHMk0eXE2Av87ysKvxoiXog5o68qCUlOx/lgHFU=";
  };

  sourceRoot = "${src.name}/python/src";

  propagatedBuildInputs = [
    google-api-core
    grpcio
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "chirpstack_api"
  ];

  meta = with lib; {
    description = "ChirpStack gRPC API message and service wrappers for Python";
    homepage = "https://github.com/brocaar/chirpstack-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
