{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylacus";
  version = "1.21.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "PyLacus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cQsrrifoDnNrliRoDoJtTgFMu8FjgSmm3Td4HXrLjwQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

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
