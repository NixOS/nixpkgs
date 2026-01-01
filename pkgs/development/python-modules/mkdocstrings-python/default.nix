{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  griffe,
  inline-snapshot,
  mkdocs-autorefs,
  mkdocs-material,
  mkdocstrings,
  pdm-backend,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mkdocstrings-python";
<<<<<<< HEAD
  version = "2.0.1";
=======
  version = "2.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "python";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-xaLC4zzX18lzYNpNJQrx3IXcZ22qQgktzzzgKDef8xE=";
=======
    hash = "sha256-3oC3eVm+RYkn+1OqUU2f/dzV/rY8T7EePDxnE/1t6n4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ pdm-backend ];

  dependencies = [
    griffe
    mkdocs-autorefs
    mkdocstrings
  ];

  nativeCheckInputs = [
    beautifulsoup4
    inline-snapshot
    mkdocs-material
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mkdocstrings_handlers" ];

  disabledTests = [
    # Tests fails with AssertionError
    "test_windows_root_conversion"
    # TypeError
    "test_format_code"
  ];

  meta = {
    description = "Python handler for mkdocstrings";
    homepage = "https://github.com/mkdocstrings/python";
    changelog = "https://github.com/mkdocstrings/python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
  };
}
