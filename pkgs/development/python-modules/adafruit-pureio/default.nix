{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pyprojectVersionPatchHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "adafruit-pureio";
  version = "1.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "Adafruit_Python_PureIO";
    tag = finalAttrs.version;
    hash = "sha256-yuDPQ30W8tU6kdruE3I0estRIoMU0RyXlowXsgP2r1I=";
  };

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  # Physical SMBus is not present
  doCheck = false;

  pythonImportsCheck = [ "Adafruit_PureIO" ];

  meta = {
    description = "Python interface to Linux IO including I2C and SPI";
    homepage = "https://github.com/adafruit/Adafruit_Python_PureIO";
    changelog = "https://github.com/adafruit/Adafruit_Python_PureIO/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
