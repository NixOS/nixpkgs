{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  jsonschema,
  pyarrow,
  typing-extensions,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "flexible-schema";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Medical-Event-Data-Standard";
    repo = "flexible_schema";
    tag = version;
    hash = "sha256-H5dnyaUDbNfA/EubX6UPteXB8dMeDMkvuJkl3SlPhRo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jsonschema
    pyarrow
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [
    "flexible_schema"
  ];

  meta = {
    description = "Specify and validate schemas for PyArrow and JSON allowing optional columns, column re-ordering, and extra columns";
    homepage = "https://flexible-schema.readthedocs.io";
    changelog = "https://github.com/Medical-Event-Data-Standard/flexible_schema/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
