{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lookyloo-models,
  poetry-core,
  pydantic,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylacus";
  version = "1.24.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "PyLacus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qrHYEt837BN24ds63TdHdhfhthYlm9spBKONyTYFePg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    lookyloo-models
    pydantic
    requests
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pylacus" ];

  meta = {
    description = "Module to enqueue and query a remote Lacus instance";
    homepage = "https://github.com/ail-project/PyLacus";
    changelog = "https://github.com/ail-project/PyLacus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
