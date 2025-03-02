{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  libpysal,
  mapclassify,
  matplotlib,
  numpy,
  scipy,
  seaborn,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "inequality";
  version = "1.1.1";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pysal";
    repo = "inequality";
    tag = "v${version}";
    hash = "sha256-JVim2u+VF35dvD+y14WbA2+G4wktAGpin/GMe0uGhjc=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    libpysal
    matplotlib
    numpy
    scipy
  ];

  nativeCheckInputs = [
    mapclassify
    pytestCheckHook
    seaborn
  ];

  pythonImportsCheck = [ "inequality" ];

  meta = {
    description = "Spatial inequality analysis";
    homepage = "https://github.com/pysal/inequality";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.geospatial.members;
  };
}
