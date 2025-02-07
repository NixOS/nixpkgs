{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  setuptools,
}:

buildPythonPackage rec {
  pname = "onedrive-personal-sdk";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "onedrive-personal-sdk";
    tag = "v${version}";
    hash = "sha256-sA+1yqRcx7WUJFuMIIuPQm7ggVbrlSCufqq0jyhDDdA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  pythonImportsCheck = [ "onedrive_personal_sdk" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/zweckj/onedrive-personal-sdk/releases/tag/${src.tag}";
    description = "Package to interact with the Microsoft Graph API for personal OneDrives";
    homepage = "https://github.com/zweckj/onedrive-personal-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
