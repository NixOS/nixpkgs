{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  poetry-core,
  pyoxigraph,
  pytestCheckHook,
  rdflib,
}:

buildPythonPackage (finalAttrs: {
  pname = "owlrl";
  version = "7.6.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RDFLib";
    repo = "OWL-RL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8P8Iuyj1WqEVx0eYxrdj1X/NpqDfBewhf/Yjn8sCO+U=";
  };

  build-system = [ poetry-core ];

  dependencies = [ rdflib ];

  optional-dependencies = {
    oxigraph = [ pyoxigraph ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "owlrl" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the OWL2 RL Profile";
    homepage = "https://github.com/RDFLib/OWL-RL";
    changelog = "https://github.com/RDFLib/OWL-RL/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.w3c;
    maintainers = with lib.maintainers; [ fab ];
  };
})
