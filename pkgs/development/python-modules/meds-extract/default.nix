{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  hydra-core,
  meds,
  meds-transforms,
  numpy,
  polars,
  pyarrow,
  universal-pathlib,
  hydra-joblib-launcher,
  meds-testing-helpers,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-notebook,
}:

buildPythonPackage rec {
  pname = "meds-extract";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mmcdermott";
    repo = "MEDS_extract";
    rev = version;
    hash = "sha256-/cALKE+xoGlneMMl+QK6soGwMMK4WgGgL2F8UqquDsQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    hydra-core
    meds
    meds-transforms
    numpy
    polars
    pyarrow
    universal-pathlib
  ];

  nativeCheckInputs = [
    hydra-joblib-launcher
    meds-testing-helpers
    meds-transforms
    pytestCheckHook
    pytest-cov-stub
    pytest-notebook
  ];

  preCheck = ''
    rm -rf src/
  '';

  optional-dependencies = {
    local_parallelism = [
      hydra-joblib-launcher
    ];
    # Not in nixpkgs:
    # slurm_parallelism = [
    #   hydra-submitit-launcher
    # ];
  };

  pythonImportsCheck = [
    "MEDS_extract"
  ];

  meta = {
    description = "Helpers to aid in building ETLs for MEDS datasets leveraging the MEDS-Transforms library";
    homepage = "https://github.com/mmcdermott/MEDS_extract.git";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
