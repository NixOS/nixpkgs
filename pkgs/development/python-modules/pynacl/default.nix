{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, libsodium
, cffi
, hypothesis
, stdenv
, six
}:

buildPythonPackage rec {
  pname = "pynacl";
  version = "1.5.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "PyNaCl";
    sha256 = "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba";
  };

  buildInputs = [
    libsodium
  ];

  propagatedNativeBuildInputs = [
    cffi
  ];

  propagatedBuildInputs = [
    cffi
    six
  ];

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  SODIUM_INSTALL = "system";

  pythonImportsCheck = [ "nacl" ];

  meta = with lib; {
    description = "Python binding to the Networking and Cryptography (NaCl) library";
    homepage = "https://github.com/pyca/pynacl/";
    license = licenses.asl20;
  };
}
