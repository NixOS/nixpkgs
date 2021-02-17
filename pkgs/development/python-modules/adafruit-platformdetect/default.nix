{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "Adafruit-PlatformDetect";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JcqDuTzR2sffEbmhJHRPJggLruc9lKQ4aO/Ab88yo/I=";
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
