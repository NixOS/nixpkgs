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
  version = "0.32.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyRFXtrx";
    tag = version;
    hash = "sha256-6gD6ch7DyaD9nCY/VfyJHmV4gEDPsDfVKjNaNedmVVE=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Library to communicate with the RFXtrx family of devices";
    homepage = "https://github.com/Danielhiversen/pyRFXtrx";
    changelog = "https://github.com/Danielhiversen/pyRFXtrx/releases/tag/${src.tag}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
