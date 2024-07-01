{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # native dependencies
  isa-l,

  # tests
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "isal";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycompression";
    repo = "python-isal";
    rev = "v${version}";
    hash = "sha256-EhdKT2ftyU2zevFg9Yi3q2FVx0FmKwJMzszsK1NS3Qg=";
  };

  build-system = [ setuptools ];

  buildInputs = [ isa-l ];

  env.PYTHON_ISAL_LINK_DYNAMIC = true;

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests" ];

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
