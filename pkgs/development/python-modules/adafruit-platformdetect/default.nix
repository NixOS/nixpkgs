{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "Adafruit-PlatformDetect";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+rZUIZA2P7NZ4jbJsenGlD0OZi5fXFQ/Y5vJo4bmvMo=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  # Project has not published tests yet
  doCheck = false;
  pythonImportsCheck = [ "adafruit_platformdetect" ];

  meta = with lib; {
    description = "Platform detection for use by Adafruit libraries";
    homepage = "https://github.com/adafruit/Adafruit_Python_PlatformDetect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
