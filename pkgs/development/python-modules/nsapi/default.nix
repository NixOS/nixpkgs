{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  pytz,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "nsapi";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aquatix";
    repo = "ns-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eZT6DU68wcEYyoFejECuluzit9MDA269zaKVFWpSuc8=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [ pytz ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ns_api" ];

  meta = {
    description = "Python module to query routes of the Dutch railways";
    homepage = "https://github.com/aquatix/ns-api/";
    changelog = "https://github.com/aquatix/ns-api/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
