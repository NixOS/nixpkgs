{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  filelock,
  hydra-core,
  meds,
  meds-testing-helpers,
  numpy,
  polars,
  pretty-print-directory,
  pyarrow,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "meds-transforms";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mmcdermott";
    repo = "MEDS_transforms";
    tag = version;
    hash = "sha256-azI+x1JCMmPpyHiJoaWOGf951ux5q2/dtvOOSGVPOyY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    filelock
    hydra-core
    meds
    meds-testing-helpers
    numpy
    polars
    pretty-print-directory
    pyarrow
  ];

  pythonRelaxDeps = [ "polars" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pytestFlagsArray = [ "tests" ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # requires unpackaged optional dependencies
    "test_example_pipeline_parallel"
  ];

  pythonImportsCheck = [
    "MEDS_transforms"
  ];

  meta = {
    description = "Simple set of Polars-based ETL and transformation functions for MEDS data";
    homepage = "https://github.com/mmcdermott/MEDS_transforms";
    changelog = "https://github.com/mmcdermott/MEDS_transforms/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
