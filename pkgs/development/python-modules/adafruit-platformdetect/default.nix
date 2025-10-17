{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "adafruit-platformdetect";
  version = "3.84.1";
  pyproject = true;

  src = fetchPypi {
    pname = "adafruit_platformdetect";
    inherit version;
    hash = "sha256-LtKS/SkuNIfbU8Jh4oea4YMcYHqOuUe+6iDfa10k5Cs=";
  };

  build-system = [ setuptools-scm ];

  # Project has not published tests yet
  doCheck = false;

  pythonImportsCheck = [ "adafruit_platformdetect" ];

  meta = with lib; {
    description = "Platform detection for use by Adafruit libraries";
    homepage = "https://github.com/adafruit/Adafruit_Python_PlatformDetect";
    changelog = "https://github.com/adafruit/Adafruit_Python_PlatformDetect/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
