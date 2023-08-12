{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiofiles";
  version = "23.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Tinche";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ouBqqt0CJYxxQqbG9jn4p8zO+nKjqZgPjZpiZic67ss=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_sendfile_file"

    # require loopback networking:
    "test_sendfile_socket"
    "test_serve_small_bin_file_sync"
    "test_serve_small_bin_file"
    "test_slow_file"
  ];

  pythonImportsCheck = [
    "aiofiles"
  ];

  meta = with lib; {
    description = "File support for asyncio";
    homepage = "https://github.com/Tinche/aiofiles";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fridh ];
  };
}
