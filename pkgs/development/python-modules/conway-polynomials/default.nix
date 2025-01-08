{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "conway-polynomials";
  version = "0.10";
  pyproject = true;

  src = fetchPypi {
    pname = "conway_polynomials";
    inherit version;
    hash = "sha256-T2GfZPgaPrFsTibFooT+7sJ6b0qtZHZD55ryiYAa4PM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "conway_polynomials" ];

  meta = with lib; {
    description = "Python interface to Frank Lübeck's Conway polynomial database";
    homepage = "https://github.com/sagemath/conway-polynomials";
    maintainers = teams.sage.members;
    license = licenses.gpl3Plus;
  };
}
