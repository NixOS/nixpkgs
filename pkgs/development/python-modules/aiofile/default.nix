{ lib
, aiomisc
, caio
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiofile";
  version = "3.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PIImQZ1ymazsOg8qmlO91tNYHwXqK/d8AuKPsWYvh0w=";
  };

  patches = [
    (fetchpatch {
      name = "remove-asynctest.patch";
      url = "https://github.com/mosquito/aiofile/commit/9253ca42022f17f630ccfb6811f67876910f8b13.patch";
      hash = "sha256-yMRfqEbdxApFypEj27v1zTgF/4kuLf5aS/+clo3mfZo=";
    })
  ];

  propagatedBuildInputs = [
    caio
  ];

  nativeCheckInputs = [
    aiomisc
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
