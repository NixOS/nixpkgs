{
  lib,
  buildPythonPackage,
  cloudpickle,
  dill,
  fasteners,
  fetchFromGitLab,
  qgrid,
  ipynbname,
  ipywidgets,
  odfpy,
  scipy,
  plotly,
  pytestCheckHook,
  pyyaml,
  tabulate,
  tensorboard,
  torch,
}:

buildPythonPackage rec {
  pname = "experiment-utilities";
  version = "0.3.6";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "creinke";
    repo = "exputils";
    domain = "gitlab.inria.fr";
    rev = "refs/tags/version_${version}";
    hash = "sha256-jo0CBSpUc/F1lJ2vagocngDM1Lopw5/AJnt1QwCunA8=";
  };

  # This dependency constraint (<=7.6.5) was due to a bug in qgrid that has been patched in its
  # owned derivation
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "ipywidgets >= 7.5.1,<= 7.6.5" "ipywidgets >= 7.5.1"
  '';

  propagatedBuildInputs = [
    cloudpickle
    dill
    fasteners
    ipynbname
    ipywidgets
    odfpy
    plotly
    pyyaml
    qgrid
    scipy
    tabulate
    tensorboard
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  disabledTests = [ "test_experimentstarter" ];

  pythonImportsCheck = [ "exputils" ];

  meta = with lib; {
    description = "Various tools to run scientific computer experiments.";
    homepage = "https://gitlab.inria.fr/creinke/exputils";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
