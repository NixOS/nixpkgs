{ lib
, buildPythonPackage
, fetchPypi
, grpcio
}:

buildPythonPackage rec {
  pname = "grpcio-gcp";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e292605effc7da39b7a8734c719afb12ec4b5362add3528d8afad3aa3aa9057c";
  };

  propagatedBuildInputs = [ grpcio ];

  meta = with lib; {
    description = "gRPC extensions for Google Cloud Platform";
    homepage = "https://grpc.io";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
