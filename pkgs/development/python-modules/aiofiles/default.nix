{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiofiles";
  version = "24.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tinche";
    repo = "aiofiles";
    tag = "v${version}";
    hash = "sha256-uDKDMSNbMIlAaifpEBh1+q2bdZNUia8pPb30IOIgOAE=";
  };

  build-system = [ hatchling ];

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

  meta = {
    description = "File support for asyncio";
    homepage = "https://github.com/Tinche/aiofiles";
    changelog = "https://github.com/Tinche/aiofiles/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
