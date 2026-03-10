{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "onedrive-personal-sdk";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "onedrive-personal-sdk";
    tag = "v${version}";
    hash = "sha256-l4cfSxF0D/qJPtA2YYcRfxMFL3TumfJw0jMQPoeIKGA=";
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
    changelog = "https://github.com/zweckj/onedrive-personal-sdk/releases/tag/${src.tag}";
    description = "Package to interact with the Microsoft Graph API for personal OneDrives";
    homepage = "https://github.com/zweckj/onedrive-personal-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
