{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pyserial,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "aurorapy";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "energievalsabbia";
    repo = "aurorapy";
    tag = finalAttrs.version;
    hash = "sha256-bc5i2x35sZXkCSJraTqX3Zc5B9eKL1qDh97/7ixyHLY=";
  };

  postPatch = ''
    sed -i "/from past.builtins import map/d" aurorapy/client.py
  '';

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "future" ];

  dependencies = [ pyserial ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "aurorapy" ];

  meta = {
    description = "Implementation of the communication protocol for Power-One Aurora inverters";
    homepage = "https://gitlab.com/energievalsabbia/aurorapy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
