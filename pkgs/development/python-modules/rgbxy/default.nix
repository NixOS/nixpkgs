{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "rgbxy";
  # version 0.5 suffix is based upon pypi version not tagged on GitHub, see:
  # - https://pypi.org/project/rgbxy/
  # - https://github.com/benknight/hue-python-rgb-converter/tags
  version = "0.5-unstable-2025-12-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benknight";
    repo = "hue-python-rgb-converter";
    rev = "22a09c3c7d395b6e7b91b5f82944ccf1a7e9e47a";
    hash = "sha256-J14vg/kDF1TuLt6kTNHN/5qxqDHbxkdGkqEAn3V57nU=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "rgbxy"
  ];

  meta = {
    description = "RGB conversion tool written in Python for Philips Hue";
    homepage = "https://github.com/benknight/hue-python-rgb-converter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
