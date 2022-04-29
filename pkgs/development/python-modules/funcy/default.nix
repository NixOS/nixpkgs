{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "1.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40b9b9a88141ae6a174df1a95861f2b82f2fdc17669080788b73a3ed9370e968";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "https://funcy.readthedocs.org/";
    license = licenses.bsd3;
  };

}
