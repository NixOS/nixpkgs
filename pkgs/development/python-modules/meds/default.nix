{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  flexible-schema,
  jsonschema,
  pyarrow,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "meds";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Medical-Event-Data-Standard";
    repo = "meds";
    tag = version;
    hash = "sha256-n9tFDI3GDzP6O0z+/JPBNy+y+pfnwcN3cgiFqSDzfPg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    flexible-schema
    jsonschema
    pyarrow
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "meds"
  ];

  meta = {
    description = "Schema definitions and Python types for the Medical Event Data Standard";
    homepage = "https://github.com/Medical-Event-Data-Standard/meds";
    changelog = "https://github.com/Medical-Event-Data-Standard/meds/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
