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
  version = "1.16.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "python";
    tag = version;
    hash = "sha256-HwGo+o78SDo+RM2UxQB4A8OTY5FVuav1TS6J+aVVWdc=";
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
    changelog = "https://github.com/mkdocstrings/python/blob/${version}/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
  };
}
