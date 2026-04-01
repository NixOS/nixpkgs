{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "growattserver";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "indykoning";
    repo = "PyPi_GrowattServer";
    tag = finalAttrs.version;
    hash = "sha256-HsBNxE1iHdZbyzGF1rKqiftDXKbOXy8Wf2rQ17kWz6k=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "growattServer" ];

  meta = {
    description = "Python package to retrieve information from Growatt units";
    homepage = "https://github.com/indykoning/PyPi_GrowattServer";
    changelog = "https://github.com/indykoning/PyPi_GrowattServer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
