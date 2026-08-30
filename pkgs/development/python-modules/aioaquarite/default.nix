{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  google-auth,
  google-cloud-firestore,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioaquarite";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdebrus";
    repo = "aioaquarite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pf/a0W1Ix/3Cd6dMUvHqb6DwT56PvtSf/GpicrL8y1A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    google-auth
    google-cloud-firestore
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aioaquarite" ];

  meta = {
    description = "Async Python client for the Hayward Aquarite pool API";
    homepage = "https://github.com/fdebrus/aioaquarite";
    changelog = "https://github.com/fdebrus/aioaquarite/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
