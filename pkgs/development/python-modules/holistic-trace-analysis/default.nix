{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  setuptools,

  # dependencies
  jupyterlab,
  numpy,
  pandas,
  plotly,
  pydot,
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "HolisticTraceAnalysis";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "HolisticTraceAnalysis";
    tag = "v${version}";
    hash = "sha256-3DuoP9gQ0vLlAAJ2uWw/oOEH/DTbn2xulzvqk4W3BiY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jupyterlab
    numpy
    pandas
    plotly
    pydot
    torch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Makes assumptions about the filesystem layout
    "tests/test_config.py"
  ];

  pythonImportsCheck = [ "hta" ];

  meta = {
    description = "Performance analysis tool to identify bottlenecks in distributed training workloads";
    homepage = "https://github.com/facebookresearch/HolisticTraceAnalysis";
    changelog = "https://github.com/facebookresearch/HolisticTraceAnalysis/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
