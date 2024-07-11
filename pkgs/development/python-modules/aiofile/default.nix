{
  lib,
  aiomisc,
  aiomisc-pytest,
  caio,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiofile";
  version = "3.8.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-KBly/aeHHZh7mL8MJ9gmxbqS7PmR4sedtBY/2HCXt54=";
  };

  propagatedBuildInputs = [ caio ];

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
    "test_modes"
    "test_text_io_wrapper"
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
