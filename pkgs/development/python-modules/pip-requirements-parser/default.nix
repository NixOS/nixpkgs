{ lib
, buildPythonPackage
, fetchFromGitHub
, packaging
, pyparsing
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pip-requirements-parser";
  version = "32.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-UMrwDXxk+sD3P2jk7s95y4OX6DRBjWWZZ8IhkR6tnZ4=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    packaging
    pyparsing
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pip_requirements_parser"
  ];

  disabledTests = [
    "test_RequirementsFile_to_dict"
    "test_RequirementsFile_dumps_unparse"
    "test_legacy_version_is_deprecated"
  ];

  meta = with lib; {
    description = "Module to parse pip requirements";
    homepage = "https://github.com/nexB/pip-requirements-parser";
    changelog = "https://github.com/nexB/pip-requirements-parser/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
