{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "adafruit-platformdetect";
  version = "3.57.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Adafruit-PlatformDetect";
    inherit version;
    hash = "sha256-tw95VnxsK57KBMw0fzzgJnFe8O8Ef0rQ9qBMIeYrkHQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  # Project has not published tests yet
  doCheck = false;

  pythonImportsCheck = [
    "adafruit_platformdetect"
  ];

  meta = with lib; {
    description = "Platform detection for use by Adafruit libraries";
    homepage = "https://github.com/adafruit/Adafruit_Python_PlatformDetect";
    changelog = "https://github.com/adafruit/Adafruit_Python_PlatformDetect/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
