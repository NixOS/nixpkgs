{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  karton-core,
  malduck,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "karton-config-extractor";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-config-extractor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EhvMPlwrKlh5M1R0mVBiSdFhPQiYjWSUKEMt200o3mI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    karton-core
    malduck
  ];

  pythonRelaxDeps = [ "malduck" ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "karton.config_extractor" ];

  meta = {
    description = "Static configuration extractor for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-config-extractor";
    changelog = "https://github.com/CERT-Polska/karton-config-extractor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "karton-config-extractor";
  };
})
