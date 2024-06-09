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
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "sarif-tools";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "sarif-tools";
    rev = "v${version}";
    hash = "sha256-80amYGnf7xZdpxzTjBGwgg39YN/jJsEkTm0uAlVbH0w=";
  };

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
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
    description = "A set of command line tools and Python library for working with SARIF files";
    homepage = "https://github.com/microsoft/sarif-tools";
    changelog = "https://github.com/microsoft/sarif-tools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puzzlewolf ];
    mainProgram = "sarif";
  };
}
