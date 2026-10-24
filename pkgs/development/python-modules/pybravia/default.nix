{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyprojectVersionPatchHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybravia";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Drafteed";
    repo = "pybravia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dHc1jmwmLRXpxxIKPMyscDtyWB/UU8xyL7Uv4ioi2TY=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pybravia" ];

  meta = {
    description = "Library for remote control of Sony Bravia TVs 2013 and newer";
    homepage = "https://github.com/Drafteed/pybravia";
    changelog = "https://github.com/Drafteed/pybravia/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
