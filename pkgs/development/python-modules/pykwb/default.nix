{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyserial,
}:

buildPythonPackage rec {
  pname = "pykwb";
  version = "0.0.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mor2TKhq08w4HzaUaspWOMEFwJaAKjXKoNAaoZJqWPQ=";
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
