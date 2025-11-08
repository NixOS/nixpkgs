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
  writableTmpDirAsHomeHook,
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

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Permission denied: '/tmp/my_saved_cp_graph/trace_data.csv'
    "test_critical_path_breakdown_and_save_restore"
    # Fails under Python 3.12 on Darwin with I/O errors
    # Permission denied: '/tmp/path_does_not_exist/...'
    "test_critical_path_overlaid_trace"
    # Permission error: [Errno 1] Operation not permitted
    "test_get_mtia_aten_op_kernels_and_delay_inference_single_rank"
    # No cuda on Darwin, can cause hangs in nixpkgs-review
    "test_frequent_cuda_kernel_sequences"
    "test_get_cuda_kernel_launch_stats_for_h100"
    "test_get_cuda_kernel_launch_stats_inference_single_rank"
    "test_get_cuda_kernel_launch_stats_training_multiple_ranks"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Makes assumptions about the filesystem layout
    "tests/test_config.py"
    # EOFError -- makes assumptions about file I/O under Python 3.12
    # https://github.com/facebookresearch/HolisticTraceAnalysis/issues/300
    "tests/test_symbol_table.py"
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
