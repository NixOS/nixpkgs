{ lib
, buildPythonPackage
, fetchFromGitHub
, packaging
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pip-requirements-parser";
  version = "32.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Wu4C93PWujygKIzXqUjCmKWcllr+hkuvnqDuw6/D9Do=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pip_requirements_parser"
  ];

  meta = with lib; {
    description = "Module to parse pip requirements";
    homepage = "https://github.com/nexB/pip-requirements-parser";
    changelog = "https://github.com/nexB/pip-requirements-parser/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
