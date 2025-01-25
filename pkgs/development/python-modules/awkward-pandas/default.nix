{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  awkward,
  pandas,
}:

buildPythonPackage rec {
  pname = "awkward-pandas";
  version = "2023.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "awkward_pandas";
    inherit version;
    hash = "sha256-Vre3NSQVAkI6ya+0nbDdO7WQWlGlPN/kdunUMWqXX94=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    awkward
    pandas
  ];

  pythonImportsCheck = [
    "awkward_pandas"
  ];

  # There are no tests in the Pypi archive
  doCheck = false;

  meta = {
    description = "Awkward Array Pandas Extension";
    homepage = "https://pypi.org/project/awkward-pandas/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
