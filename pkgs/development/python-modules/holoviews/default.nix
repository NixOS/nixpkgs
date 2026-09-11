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
  flaky,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "holoviews";
  version = "1.23.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = "holoviews";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+s7AzER7ipiqjiZL9vmno16MmhSK8Sz9LYLQ2cxNM6Y=";
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
    flaky
    pytest-asyncio
    pytestCheckHook
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
    changelog = "https://github.com/holoviz/holoviews/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "holoviews";
    homepage = "https://www.holoviews.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
