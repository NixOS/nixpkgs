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
  version = "0.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ChrisReinke";
    repo = "exputils";
    rev = "refs/tags/v${version}";
    hash = "sha256-fo8kwxm5/oEuLXVKhBrvKg18S0Yh6SkkNRaHUGJfdw4=";
  };

  pythonRelaxDeps = [
    "notebook"
    "ipywidgets"
  ];

  pythonRemoveDeps = [
    # Not available anymore in nixpkgs
    "jupyter-contrib-nbextensions"
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
