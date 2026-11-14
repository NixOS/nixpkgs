{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  setuptools_80,

  # dependencies
  choreographer,
  chromium,
  logistro,

  # tests
  pytestCheckHook,
  async-timeout,
  hypothesis,
  numpy,
  pandas,
  pytest-asyncio,
  pytest-order,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "kaleido";
  version = "1.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "Kaleido";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BXZs+gSja9E327YqsutzutUaB1NwrMDOyB2LbW5y/lM=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/py";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning"' "" \
      --replace-fail 'dynamic = ["version"]' "version = \"${finalAttrs.version}\""
  '';

  build-system = [ setuptools_80 ]; # requires `packaging`

  dependencies = [
    choreographer
    logistro
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    chromium
  ];

  pythonImportsCheck = [ "kaleido" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    chromium
  ];

  checkInputs = [
    async-timeout
    hypothesis
    numpy
    pandas
    pytest-asyncio
    pytest-order
    pytest-timeout
  ];

  # require plotly (which requires kaleido)
  disabledTests = [
    "test_all_methods_context"
    "test_all_methods_non_context"
    "test_calc_fig"
    "test_force_cdn"
    "test_headers_rendering_works"
    "test_unreasonable_timeout"
    "test_write_fig_from_object_async_generator"
    "test_write_fig_from_object_bare_dictionary"
    "test_write_fig_from_object_iterator"
    "test_write_fig_from_object_return_modes"
    "test_write_fig_from_object_sync_generator"

    # choreographer.browsers._errors.BrowserFailedError
    # (namely, can't launch a browser in the sandbox)
    "test_headers_none_by_default"
    "test_headers_stored_on_tabs"
    "test_is_running_open_close_cycle"
    "test_start_stop_sync_server_integration"

    # Tries to load plotly.js from the CDN
    "test_custom_mathjax_url"
    "test_defaults_with_plotly_available"
    "test_mathjax_false"
    "test_other_scripts"
  ];

  disabledTestPaths = [
    # Require plotly (which requires kaleido)
    "tests/test_encoder_one_off.py"
    "tests/test_large_fig.py"
    "tests/test_public_api.py::test_async_api_functions[dict]"
    "tests/test_public_api.py::test_async_api_functions[figure]"
    "tests/test_public_api.py::test_sync_api_functions[dict]"
    "tests/test_public_api.py::test_sync_api_functions[figure]"

    # choreographer.browsers._errors.BrowserFailedError
    # (namely, can't launch a browser in the sandbox)
    "tests/test_kaleido.py::test_plotlyjs_mathjax_injection"
    "tests/test_kaleido.py::test_tab_count_verification"
  ];

  meta = {
    description = "Fast static image export for web-based visualization libraries with zero dependencies";
    homepage = "https://github.com/plotly/Kaleido";
    changelog = "https://github.com/plotly/Kaleido/releases/tag/${finalAttrs.src.tag}";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pandapip1
      sarahec
    ];
  };
})
