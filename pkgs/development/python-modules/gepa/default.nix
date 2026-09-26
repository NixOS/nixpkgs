{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "gepa";
  version = "0.1.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gepa-ai";
    repo = "gepa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s9/Vjzd5/JFuMgT9huiURu6I8qlxsRagi4h6v+75IxM=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  pythonImportsCheck = [ "gepa" ];

  # test suite requires network access
  doCheck = false;

  meta = {
    description = "A framework for optimizing textual system components using LLM-based reflection and Pareto-efficient evolutionary search";
    homepage = "https://github.com/gepa-ai/gepa";
    changelog = "https://github.com/gepa-ai/gepa/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ jherland ];
    license = lib.licenses.mit;
  };
})
