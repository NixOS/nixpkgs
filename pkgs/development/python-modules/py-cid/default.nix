{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  base58,
  py-multibase,
  py-multicodec,
  morphys,
  py-multihash,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "py-cid";
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ipld";
    repo = "py-cid";
    tag = "v${version}";
    hash = "sha256-IYjk7sajHFWgsOMxwk1tWvKtTfPN8vHoNeENQed7MiU=";
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

  meta = {
    description = "Self-describing content-addressed identifiers for distributed systems implementation in Python";
    homepage = "https://github.com/ipld/py-cid";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
