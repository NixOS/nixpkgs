{
  lib,
  base58,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  morphys,
  py-multibase,
  py-multicodec,
  pymultihash,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-cid";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ipld";
    repo = "py-cid";
    tag = "v${version}";
    hash = "sha256-HvZqITvaYYnswSXb2I5xfp77ndZAwQQxGNsf/BgR+Sk=";
  };

  pythonRelaxDeps = [ "base58" ];

  build-system = [ setuptools ];

  dependencies = [
    base58
    morphys
    py-multibase
    py-multicodec
    pymultihash
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cid" ];

  meta = with lib; {
    description = "Self-describing content-addressed identifiers for distributed systems implementation in Python";
    homepage = "https://github.com/ipld/py-cid";
    changelog = "https://github.com/ipld/py-cid/blob/${src.tag}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
