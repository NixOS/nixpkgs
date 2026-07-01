{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # Build dependencies
  setuptools,

  # Runtime dependencies
  decorator,
  ipython-pygments-lexers,
  jedi,
  matplotlib-inline,
  pexpect,
  prompt-toolkit,
  psutil,
  pygments,
  stack-data,
  traitlets,
  typing-extensions,

  # Optional dependencies
  matplotlib,

  # Reverse dependency
  sage,

  # Test dependencies
  pickleshare,
  pytest-asyncio,
  pytestCheckHook,
  testpath,
}:

buildPythonPackage (finalAttrs: {
  pname = "ipython";
  version = "9.14.0";
  outputs = [
    "out"
    "man"
  ];
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-byf/Dx2eoFDgVR9xVovEs02KuleejxEcW0F19ErGtKo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    decorator
    ipython-pygments-lexers
    jedi
    matplotlib-inline
    pexpect
    prompt-toolkit
    psutil
    pygments
    stack-data
    traitlets
  ]
  ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

  optional-dependencies = {
    matplotlib = [ matplotlib ];
  };

  pythonImportsCheck = [ "IPython" ];

  preCheck = ''
    export HOME=$TMPDIR

    # doctests try to fetch an image from the internet
    substituteInPlace pyproject.toml \
      --replace-fail '"--ipdoctest-modules",' '"--ipdoctest-modules", "--ignore=IPython/core/display.py",'
  '';

  nativeCheckInputs = [
    pickleshare
    pytest-asyncio
    pytestCheckHook
    testpath
  ];

  disabledTests = [
    # timing sensitive
    "test_debug_magic_passes_through_generators"
    "test_nest_embed"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # FileNotFoundError: [Errno 2] No such file or directory: 'pbpaste'
    "test_clipboard_get"
  ];

  passthru.tests = {
    inherit sage;
  };

  meta = {
    description = "IPython: Productive Interactive Computing";
    downloadPage = "https://github.com/ipython/ipython/";
    homepage = "https://ipython.readthedocs.io/en/stable/";
    changelog = "https://github.com/ipython/ipython/blob/${finalAttrs.version}/docs/source/whatsnew/version${lib.versions.major finalAttrs.version}.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bjornfor ];
    teams = [ lib.teams.jupyter ];
  };
})
