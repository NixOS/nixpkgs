{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "1.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2775409b7dc9106283f1224d97e6df5f2c02e7291c8caed72764f5a115dffb50";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "https://funcy.readthedocs.org/";
    license = licenses.bsd3;
  };

}
