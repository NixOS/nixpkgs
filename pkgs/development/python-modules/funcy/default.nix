{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "1.18";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FUSNGajrzHpYWv56OEoZGG0L1ny/VvtCzR/Q92MT+bI=";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "https://funcy.readthedocs.org/";
    license = licenses.bsd3;
  };

}
