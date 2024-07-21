{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  indexed-bzip2,
  indexed-gzip,
  indexed-zstd,
  python-xz,
  setuptools,
  rapidgzip,
  rarfile,
  zstandard, # Python bindings
  zstd, # System tool
}:

buildPythonPackage rec {
  pname = "ratarmountcore";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mxmlnkn";
    repo = "ratarmount";
    rev = "core-v${version}";
    hash = "sha256-2jG066BUkhyHRqRyFAucQRJrjXQNw2ccCxERKkltO3Y=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/core";

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [
    indexed-gzip
    indexed-bzip2
    indexed-zstd
    python-xz
    rapidgzip
    rarfile
  ];

  pythonImportsCheck = [ "ratarmountcore" ];

  nativeCheckInputs = [
    pytestCheckHook
    zstandard
    zstd
  ];

  disabledTestPaths = [
    # Disable this test because for arcane reasons running pytest with nix-build uses 10-100x
    # more virtual memory than running the test directly or inside a local development nix-shell.
    # This virtual memory usage caused os.fork called by Python multiprocessing to fail with
    # "OSError: [Errno 12] Cannot allocate memory" on a test system with 16 GB RAM. It worked fine
    # on a system with 96 GB RAM. In order to avoid build errors on "low"-memory systems, this
    # test is disabled for now.
    "tests/test_BlockParallelReaders.py"
  ];

  meta = with lib; {
    description = "Library for accessing archives by way of indexing";
    homepage = "https://github.com/mxmlnkn/ratarmount/tree/master/core";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
  };
}
