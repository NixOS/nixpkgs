{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  numpy,
  pandas,
}:

buildPythonPackage rec {
  pname = "ancp-bids";
  version = "0.3.1";
  pyproject = true;

  # `tests/data` dir missing from PyPI dist
  src = fetchFromGitHub {
    owner = "ANCPLabOldenburg";
    repo = "ancp-bids";
    tag = version;
    hash = "sha256-brkhXz2b1nR/tjkZQZY5S+P0+GbESvJsANQcVWRCa9k=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    numpy
    pandas
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ancpbids" ];

  enabledTestPaths = [ "tests/auto" ];

  disabledTests = [ "test_fetch_dataset" ];

  meta = {
    homepage = "https://ancpbids.readthedocs.io";
    description = "Read/write/validate/query BIDS datasets";
    changelog = "https://github.com/ANCPLabOldenburg/ancp-bids/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
