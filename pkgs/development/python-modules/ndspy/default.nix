{ lib, buildPythonPackage, fetchPypi, crcmod }:

buildPythonPackage rec {
  pname = "ndspy";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3lNnbiYu2IFRUmxPURj6m+qoowGFXTLP3GI+S9beKZE=";
  };

  propagatedBuildInputs = [ crcmod ];

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "ndspy" ];

  meta = with lib; {
    homepage = "https://github.com/RoadrunnerWMC/ndspy";
    description = "A Python library for many Nintendo DS file formats";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
