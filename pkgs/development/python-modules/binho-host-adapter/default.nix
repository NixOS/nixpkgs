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
    sha256 = "0mp8xa1qwaww2k5g2nqg7mcivzsbfw2ny1l9yjsi73109slafv8y";
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
