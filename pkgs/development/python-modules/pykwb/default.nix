{ lib
, buildPythonPackage
, fetchPypi
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pykwb";
  version = "0.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mor2TKhq08w4HzaUaspWOMEFwJaAKjXKoNAaoZJqWPQ=";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pykwb"
  ];

  meta = with lib; {
    description = "Library for interacting with KWB Easyfire Pellet Central Heating Units";
    homepage = "https://github.com/bimbar/pykwb";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
