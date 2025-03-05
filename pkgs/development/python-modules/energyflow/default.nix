{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  h5py,
  numpy,
  wasserstein,

  # optional-dependencies
  igraph,
  scikit-learn,
  tensorflow,

  # tests
  pot,
  pytestCheckHook,
  tf-keras,
}:

buildPythonPackage rec {
  pname = "energyflow";
  version = "1.4.0";
  pyproject = true;

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

  disabledTests =
    [
      # Issues with array
      "test_emd_equivalence"
      "test_gdim"
      "test_n_jobs"
      "test_periodic_phi"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # RuntimeError: EMDStatus - Infeasible
      "test_emd_byhand_1_1"
      "test_emd_return_flow"
      "test_emde"
    ];

  pythonImportsCheck = [ "energyflow" ];

  meta = {
    description = "Python package for the EnergyFlow suite of tools";
    homepage = "https://energyflow.network/";
    changelog = "https://github.com/thaler-lab/EnergyFlow/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
