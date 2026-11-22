{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyrfxtrx";
  version = "0.34.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyRFXtrx";
    tag = version;
    hash = "sha256-JMAQhJP7U9xSoax3EvvlP5yrTWcteyoNjLKOxgi3Dvg=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Library to communicate with the RFXtrx family of devices";
    homepage = "https://github.com/Danielhiversen/pyRFXtrx";
    changelog = "https://github.com/Danielhiversen/pyRFXtrx/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
