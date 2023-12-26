{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dukpy";
  version = "0.3.0";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yldy6Tc/PPd3KnEeZdt2XENh3PbU5lxdiMuHnp7j9aY=";
  };
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/amol-/dukpy";
    description = "Simple JavaScript interpreter for Python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ annaaurora ];
  };
}
