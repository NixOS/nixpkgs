{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "schiene";
  version = "0.26";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-sCaVrHqQZwAZDXIjh4Rg9ZT/EQSbrOPdSyT8oofCsmA=";
  };

  propagatedBuildInputs = [
    requests
    beautifulsoup4
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "schiene" ];

  meta = {
    description = "Python library for interacting with Bahn.de";
    homepage = "https://github.com/kennell/schiene";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
