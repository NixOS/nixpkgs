{ base58
, buildPythonPackage
, fetchPypi
, isPy27
, lib
, morphys
, pytest
, pytestcov
, pytestrunner
, six
, variants
, varint
}:

buildPythonPackage rec {
  pname = "py-multihash";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version ;
    sha256 = "f0ade4de820afdc4b4aaa40464ec86c9da5cae3a4578cda2daab4b0eb7e5b18d";
  };

  nativeBuildInputs = [
    pytestrunner
  ];

  propagatedBuildInputs = [
    base58
    morphys
    six
    variants
    varint
  ];

  checkInputs = [
    pytest
    pytestcov
  ];

  disabled = isPy27;

  meta = with lib; {
    description = "Self describing hashes - for future proofing";
    homepage = "https://github.com/multiformats/py-multihash";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}