{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "reusables";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "Reusables";
    tag = version;
    hash = "sha256-l8nARlyLPMLZnIdV5IT2HeZ8duUA94cc2jWEVrBJ5wc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Requires optional rarfile dependency
    "test_extract_rar"
  ];

  pythonImportsCheck = [ "reusables" ];

  meta = {
    description = "Commonly consumed code commodities for Python";
    homepage = "https://github.com/cdgriffith/Reusables";
    changelog = "https://github.com/cdgriffith/Reusables/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
}
