{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  poetry-core,
  importlib-metadata,
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

  dependencies = lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  # no tests executed
  doCheck = false;

  pythonImportsCheck = [ "babelfish" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/Diaoul/babelfish";
    description = "Module to work with countries and languages";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    homepage = "https://github.com/Diaoul/babelfish";
    description = "Module to work with countries and languages";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
