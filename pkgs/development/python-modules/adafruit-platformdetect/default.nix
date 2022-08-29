{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "adafruit-platformdetect";
  version = "3.27.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Adafruit-PlatformDetect";
    inherit version;
    hash = "sha256-bsehvoX625Lr+5/ieYnIBUMUpkCv3mlDDCCf2UyXsMk=";
  };

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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
