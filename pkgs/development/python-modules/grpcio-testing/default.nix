{ lib
, buildPythonPackage
, fetchPypi
, grpcio
, protobuf
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "grpcio-testing";
<<<<<<< HEAD
  version = "1.57.0";
=======
  version = "1.54.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-xFMqJlY+Ehn0K3bXqdiGEvL2X3Pm7IPhHHPWTi8ecOk=";
=======
    hash = "sha256-/0LlPGUVhV7lh4RDQH7wImxaynN2wDLoELxoUUG8bpM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
<<<<<<< HEAD
      --replace '"grpcio>={version}".format(version=grpc_version.VERSION)' '"grpcio"'
=======
      --replace "'grpcio>={version}'.format(version=grpc_version.VERSION)" "'grpcio'"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  pythonImportsCheck = [
    "grpc_testing"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Testing utilities for gRPC Python";
    homepage = "https://grpc.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
