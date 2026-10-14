{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  caio,

  # tests
  aiomisc,
  aiomisc-pytest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiofile";
  version = "3.12.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "aiofile";
    tag = finalAttrs.version;
    hash = "sha256-Y79LGiPsaPxQLOCmH+MGXBcPUL+XWGje0RgYljKW11U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        'version = "3.9.0"' \
        'version = "${finalAttrs.version}"'
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    caio
  ];

  nativeCheckInputs = [
    aiomisc
    aiomisc-pytest
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiofile" ];

  disabledTests = [
    # Tests (SystemError) fails randomly during nixpkgs-review
    "test_async_open"
    "test_async_open_fp"
    "test_async_open_iter_chunked"
    "test_async_open_iter_chunked"
    "test_async_open_line_iter"
    "test_async_open_line_iter"
    "test_async_open_readline"
    "test_async_open_unicode"
    "test_binary_io_wrapper"
    "test_line_reader_one_line"
    "test_modes"
    "test_open_non_existent_file_with_append"
    "test_text_io_wrapper"
    "test_truncate"
    "test_unicode_reader"
    "test_unicode_writer"
    "test_write_read_nothing"
  ];

  meta = {
    description = "File operations with asyncio support";
    homepage = "https://github.com/mosquito/aiofile";
    changelog = "https://github.com/mosquito/aiofile/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
