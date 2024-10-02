{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiofiles";
  version = "23.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Tinche";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-EbRQD/AoTMWAlPOMWmD0UdFjRyjt5MUBkJtcydUCdHM=";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "test_sendfile_file"

    # require loopback networking:
    "test_sendfile_socket"
    "test_serve_small_bin_file_sync"
    "test_serve_small_bin_file"
    "test_slow_file"
  ];

  pythonImportsCheck = [ "aiofiles" ];

  meta = with lib; {
    description = "File support for asyncio";
    homepage = "https://github.com/Tinche/aiofiles";
    license = with licenses; [ asl20 ];
  };
}
