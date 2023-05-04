{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OWMxXVnUHG8wwEvJEOEKtQo6xKIlhov6lv7tEz3wdcs=";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "https://funcy.readthedocs.org/";
    license = licenses.bsd3;
  };

}
