{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  setuptools,
  aiohttp,
  cryptography,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-aidot";
  version = "0.3.53";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AiDot-Development-Team";
    repo = "python-AiDot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wo3eadMg1HxMjoGpiDSUImw36qN3zC5QrIAaEwdvbS8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cryptography
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
