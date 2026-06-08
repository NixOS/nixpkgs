{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OWMxXVnUHG8wwEvJEOEKtQo6xKIlhov6lv7tEz3wdcs=";
  };

  # No tests
  doCheck = false;

  meta = {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "https://funcy.readthedocs.org/";
    changelog = "https://github.com/Suor/funcy/blob/2.0/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
