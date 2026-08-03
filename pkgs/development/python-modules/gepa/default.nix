{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "gepa";
  version = "0.1.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gepa-ai";
    repo = "gepa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9gxOfjiOK1BP+YiAY4SufohMyPaUM5c7jJfJsGnRgSs=";
  };

  build-system = [ setuptools ];

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
