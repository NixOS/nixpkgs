{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysmt";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pysmt";
    repo = "pysmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MCw2a3KLROBwc0NHBz0Qf6YAsVfDt8pqyVL3G2ZkbZg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysmt" ];

  meta = {
    description = "Python library for SMT formulae manipulation and solving";
    homepage = "https://github.com/pysmt/pysmt";
    changelog = "https://github.com/pysmt/pysmt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pysmt-install";
  };
})
