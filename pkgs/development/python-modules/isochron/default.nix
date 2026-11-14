{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  # build deps
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "isochron";
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agentine";
    repo = "isochron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jlz2mg8NTQ1PQM+sWxq8rnbonAn03R+0R+UfEZqmx6o=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "isochron"
  ];

  meta = {
    description = "";
    homepage = "https://github.com/agentine/isochron";
    changelog = "https://github.com/agentine/isochron/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "isochron";
  };
})
