{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fastcore,
  httpx2,
  cachy,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "fasttransport";
  version = "0.0.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fasttransport";
    tag = finalAttrs.version;
    hash = "sha256-t0Kc/w6BTQ1l3esnGam0sY1m3/W6C00ruYsmIfNwaWA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    fastcore
    httpx2
  ];

  optional-dependencies = {
    dev = [ cachy ];
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fasttransport" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sync and async HTTP transports over httpx2, plus base classes for small REST clients";
    homepage = "https://github.com/AnswerDotAI/fasttransport";
    changelog = "https://github.com/AnswerDotAI/fasttransport/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
