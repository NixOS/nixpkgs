{
  buildPythonPackage,
  fetchPypi,
  lib,

  # build system
  setuptools,
  setuptools-scm,

  # python package dependencies
  click,
  joblib,
  line-profiler,
  mako,
  matplotlib,
  numpy,
  pandas,
  plotly,
  psutil,
  pyarrow,
  pygithub,
  pytest,
  pyyaml,
  scipy,

  # optional dependencies
  submitit,
  rich,

  # hooks
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "benchopt";
  version = "1.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/89xkqQ4bmfE+rvUzuQASa1S3h3Oqe82To0McAE5UX0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    joblib
    line-profiler
    mako
    matplotlib
    numpy
    pandas
    plotly
    psutil
    pyarrow
    pygithub
    pytest
    pyyaml
    scipy
  ];

  optional-dependencies = {
    slurm = [
      rich
      submitit
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "benchopt" ];

  disabledTests = [
    # Skip tests requiring installations via conda or pip
    "InstallCmd"
    "RunCmd"
    "invalid_install_cmd"
    "solver_install"
  ];

  meta = {
    description = "Making your ML and optimization benchmarks simple and open";
    changelog = "https://benchopt.github.io/whats_new.html";
    homepage = "https://benchopt.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jolars ];
  };
}
