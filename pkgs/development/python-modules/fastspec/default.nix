{
  lib,
  buildPythonPackage,
  fastcore,
  fasttransport,
  fetchFromGitHub,
  nix-update-script,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastspec";
  version = "0.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fastspec";
    tag = finalAttrs.version;
    hash = "sha256-vxP9u1VMDQgFnPk3Z7Ob5HNl1eYxyl5IOVEVC9LjmB4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fastcore
    fasttransport
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fastspec" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamic OpenAPI and discovery spec client for Python";
    homepage = "https://github.com/AnswerDotAI/fastspec";
    changelog = "https://github.com/AnswerDotAI/fastspec/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
