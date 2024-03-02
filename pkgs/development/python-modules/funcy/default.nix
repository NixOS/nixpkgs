{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OWMxXVnUHG8wwEvJEOEKtQo6xKIlhov6lv7tEz3wdcs=";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "https://funcy.readthedocs.org/";
    changelog = "https://github.com/Suor/funcy/blob/2.0/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}
