{
  lib,
  astroid,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "asttokens";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gristlabs";
    repo = "asttokens";
    tag = "v${version}";
    hash = "sha256-1qkkNpjX89TmGD0z0KA2y+UbiHuEOaXzZ6hs9nw7EeM=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [
    astroid
    pytestCheckHook
  ];

  disabledTests = [
    # Test is currently failing on Hydra, works locally
    "test_slices"
  ];

  disabledTestPaths = [
    # incompatible with astroid 2.11.0, pins <= 2.5.3
    "tests/test_astroid.py"
  ];

  pythonImportsCheck = [ "asttokens" ];

  meta = {
    description = "Annotate Python AST trees with source text and token information";
    homepage = "https://github.com/gristlabs/asttokens";
    changelog = "https://github.com/gristlabs/asttokens/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
