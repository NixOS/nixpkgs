{ lib
, aiomisc
, aiomisc-pytest
, caio
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiofile";
<<<<<<< HEAD
  version = "3.8.6";
=======
  version = "3.8.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-KBly/aeHHZh7mL8MJ9gmxbqS7PmR4sedtBY/2HCXt54=";
=======
    hash = "sha256-jQ97jtYhkqQgQjtHhtlk5JlvkzbFQw3kY6uXuV81ZkQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    caio
  ];

  nativeCheckInputs = [
    aiomisc
    aiomisc-pytest
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiofile"
  ];

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
