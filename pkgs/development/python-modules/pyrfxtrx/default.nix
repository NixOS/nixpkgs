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
  version = "0.31.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyRFXtrx";
    rev = "refs/tags/${version}";
    hash = "sha256-Y9UVJZxm5G5ywNLW8nm162cZTs3/mFeI+ZEUGoc9eAs=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Library to communicate with the RFXtrx family of devices";
    homepage = "https://github.com/Danielhiversen/pyRFXtrx";
    changelog = "https://github.com/Danielhiversen/pyRFXtrx/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
