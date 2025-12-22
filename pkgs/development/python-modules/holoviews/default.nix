{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  colorcet,
  numpy,
  pandas,
  panel,
  param,
  pyviz-comms,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  flaky,
}:

buildPythonPackage rec {
  pname = "holoviews";
  version = "1.22.1b1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = "holoviews";
    tag = "v${version}";
    hash = "sha256-030TJt1JM/tT1+3CRJ7DkuU7d0xWH9Ana5f3NLibDa0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"ignore:No data was collected:coverage.exceptions.CoverageWarning",' ""
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    colorcet
    numpy
    pandas
    panel
    param
    pyviz-comms
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    flaky
  ];

  pytestFlags = [
    "-Wignore::FutureWarning"
  ];

  disabledTests = [
    # All the below fail due to some change in flaky API
    "test_periodic_param_fn_non_blocking"
    "test_callback_cleanup"
    "test_poly_edit_callback"
    "test_launch_server_with_complex_plot"
    "test_launch_server_with_stream"
    "test_launch_simple_server"
    "test_server_dynamicmap_with_dims"
    "test_server_dynamicmap_with_stream"
    "test_server_dynamicmap_with_stream_dims"

    # ModuleNotFoundError: No module named 'param'
    "test_no_blocklist_imports"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fails due to font rendering differences
    "test_categorical_axis_fontsize_both"
  ];

  pythonImportsCheck = [ "holoviews" ];

  meta = {
    description = "Python data analysis and visualization seamless and simple";
    changelog = "https://github.com/holoviz/holoviews/releases/tag/${src.tag}";
    mainProgram = "holoviews";
    homepage = "https://www.holoviews.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
