{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  cryptography,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-aidot";
  version = "0.3.54b4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AiDot-Development-Team";
    repo = "python-AiDot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BZB3zEZCPG52BiOj3b/i4ckCR8IZjxoob+M2ESrhAhI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cryptography
    requests
  ];

  pythonImportsCheck = [ "aidot" ];

  meta = {
    description = "Control the WiFi lights of AIDOT in the local area network";
    homepage = "https://github.com/AiDot-Development-Team/python-AiDot";
    changelog = "https://github.com/AiDot-Development-Team/python-AiDot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
