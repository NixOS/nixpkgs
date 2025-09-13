{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
  jsonpath-ng,
  jsonschema,
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
  version = "3.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "sarif-tools";
    tag = "v${version}";
    hash = "sha256-Dt8VcYIIpujRp2sOlK2JPGzy5cYZDXdXgnvT/+h3DuU=";
  };

  disabled = pythonOlder "3.8";

  build-system = [ poetry-core ];

  dependencies = [
    jinja2
    jsonpath-ng
    matplotlib
    python
    python-docx
    pyyaml
  ];

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
  ];

  pythonRelaxDeps = [ "python-docx" ];

  disabledTests = [
    # Broken, re-enable once https://github.com/microsoft/sarif-tools/pull/41 is merged
    "test_version"
  ];

  pythonImportsCheck = [ "sarif" ];

  meta = {
    description = "Set of command line tools and Python library for working with SARIF files";
    homepage = "https://github.com/microsoft/sarif-tools";
    changelog = "https://github.com/microsoft/sarif-tools/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puzzlewolf ];
    mainProgram = "sarif";
  };
}
