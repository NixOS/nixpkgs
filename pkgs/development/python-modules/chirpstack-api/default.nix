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

<<<<<<< HEAD
  sourceRoot = "${src.name}/python/src";
=======
  sourceRoot = "source/python/src";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
