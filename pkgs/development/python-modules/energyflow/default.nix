{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  h5py,
  hatch-vcs,
  hatchling,
  igraph,
  numpy,
  pot,
  pytestCheckHook,
  pythonOlder,
  scikit-learn,
  tensorflow,
  tf-keras,
  wasserstein,
}:

buildPythonPackage rec {
  pname = "energyflow";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pkomiske";
    repo = "EnergyFlow";
    tag = "v${version}";
    hash = "sha256-4RzhpeOOty8IaVGByHD+PyeaeWgR7ZF98mSCJYoM9wY=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    h5py
    numpy
    wasserstein
  ];

  optional-dependencies = {
    all = [
      igraph
      scikit-learn
      tensorflow
    ];
    archs = [
      scikit-learn
      tensorflow
    ];
    generation = [ igraph ];
  };

  nativeCheckInputs = [
    pot
    pytestCheckHook
    tf-keras
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTests = [
    # Issues with array
    "test_emd_equivalence"
    "test_gdim"
    "test_n_jobs"
    "test_periodic_phi"
  ];

  pythonImportsCheck = [ "energyflow" ];

  meta = with lib; {
    description = "Python package for the EnergyFlow suite of tools";
    homepage = "https://energyflow.network/";
    changelog = "https://github.com/thaler-lab/EnergyFlow/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ veprbl ];
  };
}
