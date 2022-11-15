{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, aiolifx
}:

buildPythonPackage rec {
  pname = "aiolifx-effects";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "aiolifx_effects";
    hash = "sha256-6mFsQMrsEMhO9drsMMRhv8QY+eDPuskpJyazx3vG7Ko=";
  };

  propagatedBuildInputs = [
    aiolifx
  ];

  # tests are not implemented
  doCheck = false;

  pythonImportsCheck = [
    "aiolifx_effects"
  ];

  meta = with lib; {
    description = "Light effects (pulse, colorloop ...) for LIFX lights running on aiolifx";
    homepage = "https://github.com/amelchio/aiolifx_effects";
    license = licenses.mit;
    maintainers = with maintainers; [ netixx ];
  };
}
