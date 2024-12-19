{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  libpysal,
  numpy,
  scipy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "inequality";
  version = "1.0.1";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pysal";
    repo = "inequality";
    rev = "v${version}";
    hash = "sha256-dy1/KXnmIh5LnTxuyYfIvtt1p2CIpNQ970o5pTg6diQ=";
  };

  build-system = [ setuptools-scm ];

  propagatedBuildInputs = [
    libpysal
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "inequality" ];

  meta = {
    description = "Spatial inequality analysis";
    homepage = "https://github.com/pysal/inequality";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.geospatial.members;
  };
}
