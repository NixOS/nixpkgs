{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyserial,
}:

buildPythonPackage rec {
  pname = "binho-host-adapter";
  version = "0.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hm2nqE4gjBO19IkGbwV3S/8dWT0PW/HKFJwrjoPq6FY=";
  };

  propagatedBuildInputs = [ pyserial ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "binhoHostAdapter" ];

  meta = with lib; {
    description = "Python library for Binho Multi-Protocol USB Host Adapters";
    homepage = "https://github.com/adafruit/Adafruit_Python_PlatformDetect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
