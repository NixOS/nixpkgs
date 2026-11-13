{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  numpy,
  scipy,
  matplotlib,
  pandas,
  multiprocess,
  pathos,
}:
let
  finalAttrs = {
    pname = "salib";
    version = "1.6.0";
    pyproject = true;

    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-Ei0lgWE3pQtelyogbecRiWHiAqb7CSLZ7IdP1J/bv18=";
    };

    build-system = [
      hatchling
      hatch-vcs
    ];

    dependencies = [
      numpy
      scipy
      matplotlib
      pandas
      multiprocess
    ];

    optional-dependencies = {
      distributed = [ pathos ];
    };

    # There are no tests in the pypi package
    doCheck = false;

    pythonImportsCheck = [
      "SALib"
      "SALib.analyze"
      "SALib.plotting"
      "SALib.sample"
      "SALib.test_functions"
      "SALib.util"
    ];

    meta = {
      changelog = "https://github.com/SALib/SALib/releases";
      description = "Python implementations of commonly used sensitivity analysis methods, useful in systems modeling to calculate the effects of model inputs or exogenous factors on outputs of interest";
      homepage = "https://github.com/SALib/SALib";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ theobori ];
      mainProgram = "salib";
    };
  };
in
buildPythonPackage finalAttrs
