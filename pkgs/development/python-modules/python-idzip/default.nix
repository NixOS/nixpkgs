{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  pythonOlder,

  setuptools,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-idzip";
  version = "0.3.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bauman";
    repo = "python-idzip";
    tag = version;
    hash = "sha256-ChzwC/Afn0qeo5anq4anIu2eI9i6XDnSvB7jAwY7rSw=";
  };

  patches = [
    # fix collision
    # https://github.com/bauman/python-idzip/pull/23
    (fetchpatch {
      name = "fix-bin-folder-collisions.patch";
      url = "https://patch-diff.githubusercontent.com/raw/bauman/python-idzip/pull/23.patch";
      hash = "sha256-4fPhLdY9MaH1aX6tqMT+NNNNDsyv87G0xBh4MC+5yQE=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # need third-party files
    # https://github.com/bauman/python-idzip/blob/master/.github/workflows/test.yaml#L2https://github.com/bauman/python-idzip/blob/master/.github/workflows/test.yaml#L288
    "test/test_compressor.py"
    "test/test_decompressor.py"
    "test/test_lucky_cache.py"
    "test/test_readline.py"
    "test/test_seek_read_behavior.py"
    "test/test_zero_cache.py"
  ];

  disabledTests = [
    # Terminated
    # pop_var_context: head of shell_variables not a function context
    "test_bufferedio_compat"
  ];

  meta = with lib; {
    description = "Seekable, gzip compatible, compression format";
    mainProgram = "idzip";
    homepage = "https://github.com/bauman/python-idzip";
    changelog = "https://github.com/bauman/python-idzip/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
