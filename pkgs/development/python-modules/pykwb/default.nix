{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyserial,
}:

buildPythonPackage rec {
  pname = "pykwb";
  version = "0.0.21";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-53or6KOjZujOIq9yZ30Ph704I8T93AX/EoJZeVS3ihI=";
  };

  propagatedBuildInputs = [ pyserial ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykwb" ];

  meta = {
    description = "Library for interacting with KWB Easyfire Pellet Central Heating Units";
    homepage = "https://github.com/bimbar/pykwb";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
