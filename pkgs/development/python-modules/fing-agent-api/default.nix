{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fing-agent-api";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fingltd";
    repo = "fing-agent-pyapi";
    tag = finalAttrs.version;
    hash = "sha256-tkFTkWYvWw/x2k+jT6lu/Takacm6aDX4hn8thnGZf5g=";
  };

  build-system = [ setuptools ];

  dependencies = [ httpx ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "fing_agent_api" ];

  meta = {
    changelog = "https://github.com/fingltd/fing-agent-pyapi/releases/tag/${finalAttrs.version}";
    description = "Python library for interacting with the Fingbox local APIs";
    homepage = "https://github.com/fingltd/fing-agent-pyapi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
})
