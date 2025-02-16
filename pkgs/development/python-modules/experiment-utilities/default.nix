{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  cloudpickle,
  dill,
  fasteners,
  ipynbname,
  ipywidgets,
  notebook,
  numpy,
  odfpy,
  plotly,
  pyyaml,
  qgrid,
  scipy,
  six,
  tabulate,
  tensorboard,

  # tests
  pytestCheckHook,
  torch,
}:

buildPythonPackage rec {
  pname = "experiment-utilities";
  version = "0.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ChrisReinke";
    repo = "exputils";
    tag = "v${version}";
    hash = "sha256-LQ1RjDcOL1SroNzWSfSS2OUSqsGgWOly7bLcbZ7e8LY=";
  };

  pythonRelaxDeps = [
    "notebook"
    "ipywidgets"
  ];

  pythonRemoveDeps = [
    # Not available anymore in nixpkgs
    "jupyter_contrib_nbextensions"
  ];

  dependencies = [
    cloudpickle
    dill
    fasteners
    ipynbname
    ipywidgets
    notebook
    numpy
    odfpy
    plotly
    pyyaml
    qgrid
    scipy
    six
    tabulate
    tensorboard
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  disabledTests = [ "test_experimentstarter" ];

  pythonImportsCheck = [ "exputils" ];

  meta = {
    description = "Various tools to run scientific computer experiments";
    homepage = "https://gitlab.inria.fr/creinke/exputils";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/ChrisReinke/exputils/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
