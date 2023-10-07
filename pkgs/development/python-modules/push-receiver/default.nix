{ buildPythonPackage
, fetchPypi
, lib
, appdirs
, http-ece
, oscrypto
, protobuf
}:

buildPythonPackage rec {
  pname = "push-receiver";
  version = "0.1.1";

  src = fetchPypi {
    inherit version;
    pname = "push_receiver";
    hash = "sha256-Tknmra39QfA+OgrRxzKDLbkPucW8zgdHqz5FGQnzYOw=";
  };

  propagatedBuildInputs = [
    appdirs # required for running the bundled example
    http-ece # required for listening for new message
    oscrypto
    protobuf
  ];

  pythonImportsCheck = [ "push_receiver" ];

  meta = with lib; {
    homepage = "https://github.com/Francesco149/push_receiver";
    description = "Subscribe to GCM/FCM and receive notifications";
    license = licenses.unlicense;
    maintainers = with maintainers; [ veehaitch ];
  };
}
