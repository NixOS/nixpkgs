{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  setuptools,
  aiohttp,
  cryptography,
  dacite,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-aidot";
  version = "0.3.56";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AiDot-Development-Team";
    repo = "python-AiDot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6C1+uuTVq/0xsIse6d3+tm6H84PGFIUYvgYffU8XUQs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cryptography
    dacite
    requests
  ];

  pythonImportsCheck = [ "aidot" ];

  # Upstream publishes pre-release tags (e.g. v0.3.54b4) alongside
  # stable ones. Restrict automatic updates to stable versions only.
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Control the WiFi lights of AIDOT in the local area network";
    homepage = "https://github.com/AiDot-Development-Team/python-AiDot";
    changelog = "https://github.com/AiDot-Development-Team/python-AiDot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
