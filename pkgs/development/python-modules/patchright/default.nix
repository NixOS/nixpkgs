{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  playwright,
  setuptools,
  toml,
}:

buildPythonPackage (finalAttrs: {
  pname = "patchright";
  version = "1.61.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kaliiiiiiiiii-Vinyzu";
    repo = "patchright-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2CiN1yxX0Bn+codnzb5DOVR4Dq4ZCICiUItXJjSP4n0=";
  };

  # https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python/pull/120
  patches = [ ./match-pyproject-to-package.patch ];

  build-system = [ setuptools ];

  # No external dependencies.

  # Module has no tests
  doCheck = false;

  # pythonImportsCheck disabled: module attempts filesystem writes at import time
  pythonImportsCheck = [ ];

  meta = {
    description = "Undetected Python version of the Playwright testing and automation library";
    homepage = "https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python";
    changelog = "https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
