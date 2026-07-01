{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  ase,
  configargparse,
  e3nn,
  gitpython,
  h5py,
  lmdb,
  matplotlib,
  matscipy,
  numpy,
  opt-einsum,
  orjson,
  pandas,
  prettytable,
  python-hostlist,
  pyyaml,
  torch,
  torch-ema,
  torchmetrics,
  tqdm,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mace-torch";
  version = "0.3.16";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "acesuit";
    repo = "mace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sJ/3c7kPe99vkliixUMqqQi2OiL3CCUdlcgpDZ/PUHA=";
  };

  build-system = [
    setuptools
  ];

  env = {
    # Skip the most intensive tests
    CI = true;
  };

  pythonRelaxDeps = [
    "e3nn"
  ];
  dependencies = [
    ase
    configargparse
    e3nn
    gitpython
    h5py
    lmdb
    matplotlib
    matscipy
    numpy
    opt-einsum
    orjson
    pandas
    prettytable
    python-hostlist
    pyyaml
    torch
    torch-ema
    torchmetrics
    tqdm
  ];

  pythonImportsCheck = [ "mace" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export OMP_NUM_THREADS=1
  '';

  disabledTests = [
    # _pickle.PickleError: ScriptFunction cannot be pickled
    "test_run_eval_fail_with_wrong_model"

    # ValueError: too many values to unpack (expected 2)
    "test_mace_mp"

    # AssertionError (tensors not close)
    "test_run_train_dipole"
    "test_run_train_dipole_polar"

    # RuntimeError: Model download failed and no local model found
    "test_calculator_descriptor"
    "test_compile_foundation"
    "test_extract_config"
    "test_finite_difference_hessian"
    "test_foundations"
    "test_initial_metrics_replay_head_mh0"
    "test_initial_metrics_replay_head_mh1"
    "test_initial_metrics_replay_head_omol"
    "test_mace_mh_1_elements_subset_reproduces_energy_forces"
    "test_mace_mp_energies"
    "test_mace_mp_stresses"
    "test_mace_off"
    "test_mace_omol_elements_subset_reproduces_energy_forces"
    "test_multi_reference"
    "test_multihead_finetuning_different_formats"
    "test_multihead_finetuning_does_not_modify_default_keyspec"
    "test_potential_energy_and_hessian"
    "test_remove_pt_head_omol_multihead"
    "test_run_train_foundation"
    "test_run_train_foundation_elements"
    "test_run_train_foundation_elements_multihead"
    "test_run_train_foundation_multihead"
    "test_run_train_foundation_multihead_json"
    "test_run_train_foundation_multihead_pseudolabeling"
    "test_run_train_freeze"
    "test_run_train_mh_foundation"
    "test_run_train_soft_freeze"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # symbol not found in flat namespace '___kmpc_barrier'
    "test_mace"
    "test_mace_compile_stress"
  ];

  meta = {
    description = "Fast and accurate machine learning interatomic potentials with higher order equivariant message passing";
    homepage = "https://github.com/acesuit/mace";
    changelog = "https://github.com/acesuit/mace/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
