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
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "DAB-LABS";
    repo = "broadlink-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AZo0DVRDK6gyV67EUPGujmv73MuXKPi7QPjegGwsl5g=";
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
