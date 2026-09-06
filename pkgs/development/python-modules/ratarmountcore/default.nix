{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fsspec,
  indexed-gzip,
  indexed-zstd,
  libarchive-c,
  pytestCheckHook,
  python-xz,
  writableTmpDirAsHomeHook,
  rapidgzip,
  rarfile,
  setuptools,
  zstandard, # Python bindings
  zstd, # System tool
}:

buildPythonPackage rec {
  pname = "ratarmountcore";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mxmlnkn";
    repo = "ratarmount";
    tag = "core-v${version}";
    hash = "sha256-7xknOpJIjXMr7Z7JD3Jn3oma63hbEZcj/1zQ6FAp5aA=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/core";

  postPatch = ''
    substituteInPlace tests/test_AutoMountLayer.py \
      --replace-fail 'f"tests/{name}.tgz.tgz.gz"' 'os.path.join(os.path.dirname(__file__), f"../../tests/{name}.tgz.tgz.gz")' \
      --replace-fail 'copy_test_file("tests/double-compressed-nested-tar.tgz.tgz")' 'copy_test_file(os.path.join(os.path.dirname(__file__), "../../tests/double-compressed-nested-tar.tgz.tgz"))'
  '';

  build-system = [ setuptools ];

  optional-dependencies = {
    full = [
      indexed-gzip
      indexed-zstd
      python-xz
      rapidgzip
      rarfile
    ];
    _7z = [ libarchive-c ];
    bzip2 = [ rapidgzip ];
    gzip = [ indexed-gzip ];
    rar = [ rarfile ];
    xz = [ python-xz ];
    zstd = [ indexed-zstd ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    zstandard
    zstd
    fsspec
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "ratarmountcore" ];

  disabledTestPaths = [
    # Disable this test because for arcane reasons running pytest with nix-build uses 10-100x
    # more virtual memory than running the test directly or inside a local development nix-shell.
    # This virtual memory usage caused os.fork called by Python multiprocessing to fail with
    # "OSError: [Errno 12] Cannot allocate memory" on a test system with 16 GB RAM. It worked fine
    # on a system with 96 GB RAM. In order to avoid build errors on "low"-memory systems, this
    # test is disabled for now.
    "tests/test_BlockParallelReaders.py"
  ];

  disabledTests = [
    # Tests with issues
    "test_file_versions"
    "test_stream_compressed"
    "test_chimera_file"
    "test_URLContextManager"
    "test_URL"
  ];

  meta = {
    description = "Library for accessing archives by way of indexing";
    homepage = "https://github.com/mxmlnkn/ratarmount/tree/master/core";
    changelog = "https://github.com/mxmlnkn/ratarmount/blob/${src.rev}/core/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
  };
}
