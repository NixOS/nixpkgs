{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  pycryptodome,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "panasonic-viera";
  version = "0.4.0";

  format = "setuptools";

  src = fetchPypi {
    pname = "panasonic_viera";
    inherit version;
    sha256 = "baad2db7958ddbc7288d0f1c50a9eeddd8b83f3d30ad14ac3f6c51fe953e0eb6";
  };

  propagatedBuildInputs = [
    aiohttp
    pycryptodome
    xmltodict
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "panasonic_viera" ];

  meta = {
    description = "Library to control Panasonic Viera TVs";
    homepage = "https://github.com/florianholzapfel/panasonic-viera";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
