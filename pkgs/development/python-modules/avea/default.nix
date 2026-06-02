{
  lib,
  bleak-retry-connector,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "avea";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "k0rventen";
    repo = "avea";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cBYS8Q70K5MXZ63uI6OGkUsskJ7rkgTBPjlAsxmtmVA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "avea" ];

  meta = {
    description = "Python module for interacting with Elgato's Avea bulb";
    homepage = "https://github.com/k0rventen/avea";
    changelog = "https://github.com/k0rventen/avea/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
