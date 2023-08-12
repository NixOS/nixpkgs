{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, base58
, py-multibase
, py-multicodec
, morphys
, py-multihash
, hypothesis
}:

buildPythonPackage rec {
  pname = "py-cid";
  version = "0.3.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ipld";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aN7ee25ghKKa90+FoMDCdGauToePc5AzDLV3tONvh4U=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "base58>=1.0.2,<2.0" "base58>=1.0.2" \
      --replace "py-multihash>=0.2.0,<1.0.0" "py-multihash>=0.2.0" \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    base58
    py-multibase
    py-multicodec
    morphys
    py-multihash
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "cid" ];

  meta = with lib; {
    description = "Self-describing content-addressed identifiers for distributed systems implementation in Python";
    homepage = "https://github.com/ipld/py-cid";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
