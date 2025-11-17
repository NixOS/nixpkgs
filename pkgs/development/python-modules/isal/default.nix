{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # native dependencies
  isa-l,

  # tests
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "isal";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycompression";
    repo = "python-isal";
    tag = "v${version}";
    hash = "sha256-703uXty3a0N+yXfv/7nVIAnU7PaqMtNO0ScltNLJq3g=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ isa-l ];

  env.PYTHON_ISAL_LINK_DYNAMIC = true;

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # calls `python -m isal` and fails on import
    "test_compress_fast_best_are_exclusive"
    "test_compress_infile_outfile"
    "test_compress_infile_outfile_default"
    "test_decompress_cannot_have_flags_compression"
    "test_decompress_infile_outfile_error"
  ];

  pythonImportsCheck = [ "isal" ];

  meta = with lib; {
    changelog = "https://github.com/pycompression/python-isal/blob/${src.rev}/CHANGELOG.rst";
    description = "Faster zlib and gzip compatible compression and decompression by providing python bindings for the isa-l library";
    homepage = "https://github.com/pycompression/python-isal";
    license = licenses.psfl;
    maintainers = with maintainers; [ hexa ];
  };
}
