{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "miniful";
  version = "0.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ZCyfNrh8gbPvwplHN5tbmbjTMYXJBKe8Mg2JqOGHFCk=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "miniful" ];

  meta = {
    description = "Minimal Fuzzy Library";
    homepage = "https://github.com/aresio/miniful";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
