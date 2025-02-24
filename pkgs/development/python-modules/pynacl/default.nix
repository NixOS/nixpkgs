{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
  pytestCheckHook,
  sphinxHook,
  pythonOlder,
  libsodium,
  cffi,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "pynacl";
  version = "1.5.0";
  outputs = [
    "out"
    "doc"
  ];
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "PyNaCl";
    sha256 = "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba";
  };

  patches = [
    (fetchpatch2 {
      # sphinx 8 compat
      url = "https://github.com/pyca/pynacl/commit/81943b3c61b9cc731ae0f2e87b7a91e42fbc8fa1.patch";
      hash = "sha256-iO3pBqGW2zZE8lG8khpPjqJso9/rmFbdnwCcBs8iFeI=";
    })
  ];

  nativeBuildInputs = [ sphinxHook ];

  buildInputs = [ libsodium ];

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  SODIUM_INSTALL = "system";

  pythonImportsCheck = [ "nacl" ];

  meta = with lib; {
    description = "Python binding to the Networking and Cryptography (NaCl) library";
    homepage = "https://github.com/pyca/pynacl/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
