{
  buildPythonPackage,
  fetchFromGitHub,
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

buildPythonPackage {
  pname = "benchopt";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benchopt";
    repo = "benchopt";
    rev = "5d2a17399beac44775807c59ec8c16d9996997d2";
    hash = "sha256-WfvVdgTFrbwdZy7f451GtnEHo0K7KFaxXrCkcahuDpw=";
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
