{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "broadlink-async";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "DAB-LABS";
    repo = "broadlink-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AyiyiYUUl1n0rs9CpeeigXo8ArpFDJwoSVmJt8zk484=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "broadlink_async" ];

  meta = {
    description = "Python API for controlling Broadlink devices";
    homepage = "https://github.com/DAB-LABS/broadlink-async";
    changelog = "https://github.com/DAB-LABS/broadlink-async/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
