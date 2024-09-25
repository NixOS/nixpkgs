{
  lib,
  aiomisc,
  aiomisc-pytest,
  caio,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiofile";
  version = "3.8.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "aiofile";
    rev = "refs/tags/${version}";
    hash = "sha256-KBly/aeHHZh7mL8MJ9gmxbqS7PmR4sedtBY/2HCXt54=";
  };

  build-system = [ setuptools ];

  dependencies = [ caio ];

  nativeCheckInputs = [
    aiomisc
    aiomisc-pytest
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiofile" ];

  disabledTests = [
    # Tests (SystemError) fails randomly during nix-review
    "test_async_open_fp"
    "test_async_open_iter_chunked"
    "test_async_open_iter_chunked"
    "test_async_open_line_iter"
    "test_async_open_line_iter"
    "test_async_open_readline"
    "test_async_open_unicode"
    "test_async_open"
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

  meta = with lib; {
    description = "File operations with asyncio support";
    homepage = "https://github.com/mosquito/aiofile";
    changelog = "https://github.com/aiokitchen/aiomisc/blob/master/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
