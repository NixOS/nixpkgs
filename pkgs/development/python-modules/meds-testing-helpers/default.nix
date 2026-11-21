{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  annotated-types,
  hydra-core,
  meds,
  numpy,
  polars,
  pyarrow,
  pytestCheckHook,
  pytimeparse,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "meds-testing-helpers";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Medical-Event-Data-Standard";
    repo = "meds_testing_helpers";
    rev = version;
    hash = "sha256-I9ohHNHi0GBe9agcKkGTuNtiWLuMle88hbRoODw9VnY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    annotated-types
    hydra-core
    meds
    numpy
    polars
    pyarrow
    pytimeparse
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  # tests do not support being run from root of source tree;
  # also, src/ contains some additional doctests but some fail on aarch64
  # due to formatting width issues
  preCheck = ''
    export PATH=$out/bin:$PATH
    cd tests/
  '';

  pythonImportsCheck = [
    "meds_testing_helpers"
  ];

  meta = {
    description = "Testing, benchmarking, and synthetic data generation helpers for MEDS tools, pipelines, and models";
    homepage = "https://meds-testing-helpers.readthedocs.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
