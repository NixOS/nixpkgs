{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "babelfish";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3stnpGYIiNSEgKtpmDCYNxdBWNDxqmO+uxwuEaq5eqs=";
  };

  build-system = [ poetry-core ];

  # no tests executed
  doCheck = false;

  pythonImportsCheck = [ "babelfish" ];

  meta = {
    homepage = "https://github.com/Diaoul/babelfish";
    description = "Module to work with countries and languages";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
