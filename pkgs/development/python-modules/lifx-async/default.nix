{
  lib,
  buildPythonPackage,
  coverage,
  fetchFromGitHub,
  hatchling,
  lifx-emulator-core,
  pytest-asyncio,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-retry,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lifx-async";
  version = "7.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Djelibeybi";
    repo = "lifx-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GZZy58gRrR+D8plarDibdYyzBq68tz50RMRW/d9Pxm0=";
  };

  build-system = [ hatchling ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    coverage # undocumented, indirect dependency of pytest-cov
    lifx-emulator-core
    pytest-asyncio
    pytest-benchmark
    pytest-cov-stub
    pytest-retry
    pytest-timeout
    pytestCheckHook
  ];

  disabledTestPaths = [
    # those tests require ruff formatter
    "tests/test_products/test_product_generator.py::TestFormatGeneratedFiles::test_formats_generated_file_in_place"
    "tests/test_protocol/test_protocol_generator.py::TestFormatGeneratedFiles::test_formats_generated_file_in_place"
    "tests/test_theme/test_theme_generator.py::TestMainAtomicWrite::test_success_replaces_target_and_leaves_no_stray_file"
    "tests/test_theme/test_theme_generator.py::TestMainAtomicWrite::test_generated_module_is_world_readable_under_any_umask"
  ];

  pythonImportsCheck = [ "lifx" ];

  meta = {
    description = "Modern, type-safe, async Python library for controlling LIFX lights";
    homepage = "https://github.com/Djelibeybi/lifx-async/";
    license = lib.licenses.upl;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
