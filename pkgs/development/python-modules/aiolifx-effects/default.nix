{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, aiolifx
}:

buildPythonPackage rec {
  pname = "aiolifx-effects";
  version = "0.3.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit version;
    pname = "aiolifx_effects";
    sha256 = "sha256-6mFsQMrsEMhO9drsMMRhv8QY+eDPuskpJyazx3vG7Ko=";
  };

  propagatedBuildInputs = [ aiolifx ];

  # tests are not implemented
  doCheck = false;

  pythonImportsCheck = [ "aiolifx_effects" ];

  meta = with lib; {
    homepage = "https://github.com/amelchio/aiolifx_effects";
    license = licenses.mit;
    description = "Light effects (pulse, colorloop ...) for LIFX lights running on aiolifx";
    maintainers = with maintainers; [ netixx ];
  };
}
