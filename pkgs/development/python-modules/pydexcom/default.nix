{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydexcom";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gagebenne";
    repo = "pydexcom";
    tag = finalAttrs.version;
    hash = "sha256-u94OI45PmofPLpuJUpjbvGLla+mJEHy1t6/4fiI6+zc=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ requests ];

  # Tests are interacting with the Dexcom API
  doCheck = false;

  pythonImportsCheck = [ "pydexcom" ];

  meta = {
    description = "Python API to interact with Dexcom Share service";
    homepage = "https://github.com/gagebenne/pydexcom";
    changelog = "https://github.com/gagebenne/pydexcom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
