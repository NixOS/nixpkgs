{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, libsodium
, cffi
, hypothesis
, six
}:

buildPythonPackage rec {
  pname = "pynacl";
  version = "1.4.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "PyNaCl";
    sha256 = "01b56hxrbif3hx8l6rwz5kljrgvlbj7shmmd2rjh0hn7974a5sal";
  };

  buildInputs = [
    libsodium
  ];

  propagatedNativeBuildInputs = [
    cffi
  ];

  propagatedBuildInputs = [
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
