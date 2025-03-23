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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mkdocstrings-python";
  version = "1.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "python";
    tag = version;
    hash = "sha256-NgVCKV3AWk4pRT7/+6YGXmKSZETL4ZOWDWGeb/qjdng=";
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

  meta = with lib; {
    description = "Python handler for mkdocstrings";
    homepage = "https://github.com/mkdocstrings/python";
    changelog = "https://github.com/mkdocstrings/python/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
