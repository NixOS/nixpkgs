{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "geomag";
  version = "0.9.2015";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+j91RL7KLdcGwweNnVjLNXNNAN4lkScKM1IWu4ujENU=";
    extension = "zip";
  };

  doCheck = false;

  build-system = [ setuptools ];

  pythonImportsCheck = [ "geomag" ];

  meta = {
    description = "Calculates magnetic variation/declination for any latitude/longitude/altitude,
for any date";
    homepage = "https://github.com/cmweiss/geomag/tree/master";
    license = lib.licenses.gpl1Only;
    maintainers = with lib.maintainers; [ dylan-gonzalez ];
  };
}
