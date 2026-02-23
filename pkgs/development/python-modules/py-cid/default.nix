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
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-cid";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ipld";
    repo = "py-cid";
    tag = "v${version}";
    hash = "sha256-IYjk7sajHFWgsOMxwk1tWvKtTfPN8vHoNeENQed7MiU=";
  };

  pythonRelaxDeps = [ "base58" ];

  build-system = [ setuptools ];

  dependencies = [
    base58
    py-multibase
    py-multicodec
    morphys
    py-multihash
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    hypothesis
  ];

  pythonImportsCheck = [ "cid" ];

  meta = {
    description = "Self-describing content-addressed identifiers for distributed systems implementation in Python";
    homepage = "https://github.com/ipld/py-cid";
    changelog = "https://github.com/ipld/py-cid/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
