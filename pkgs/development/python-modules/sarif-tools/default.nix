{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
  jsonpath-ng,
  jinja2,
  python,
  python-docx,
  matplotlib,
  pyyaml,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sarif-tools";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "sarif-tools";
    rev = "refs/tags/v${version}";
    hash = "sha256-MYwhewUTZ3Wl93p6bN3+bHqtXz+BAlAhte+JaetPQYU=";
  };

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jsonpath-ng
    jinja2
    python
    python-docx
    matplotlib
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonRelaxDeps = [ "python-docx" ];

  disabledTests = [
    # Broken, re-enable once https://github.com/microsoft/sarif-tools/pull/41 is merged
    "test_version"
  ];

  pythonImportsCheck = [ "sarif" ];

  meta = {
    description = "Set of command line tools and Python library for working with SARIF files";
    homepage = "https://github.com/microsoft/sarif-tools";
    changelog = "https://github.com/microsoft/sarif-tools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puzzlewolf ];
    mainProgram = "sarif";
  };
}
