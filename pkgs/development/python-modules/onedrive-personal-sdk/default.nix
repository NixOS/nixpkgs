{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  numpy,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "onedrive-personal-sdk";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "onedrive-personal-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fWD0GxGSNQZyVZoQRDP3KD3VS716BnptYmDxkmNw0Bs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
    numpy
  ];

  pythonImportsCheck = [ "onedrive_personal_sdk" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/zweckj/onedrive-personal-sdk/releases/tag/${finalAttrs.src.tag}";
    description = "Package to interact with the Microsoft Graph API for personal OneDrives";
    homepage = "https://github.com/zweckj/onedrive-personal-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
