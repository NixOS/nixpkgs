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
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "onedrive-personal-sdk";
    tag = "v${version}";
    hash = "sha256-4/v1kAgpg/D7HPTirS+HBs46Vs/OK81MzUW8ixhzU+Y=";
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
