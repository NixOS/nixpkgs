{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
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

buildPythonPackage rec {
  pname = "ipython";
  version = "9.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wDPG1OeRTD2XaKq+drvoe6HcZqkqBdtr+hEl2B8u4nA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    decorator
    ipython-pygments-lexers
    jedi
    matplotlib-inline
    pexpect
    prompt-toolkit
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
    # UnboundLocalError: local variable 'child' referenced before assignment
    "test_system_interrupt"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # AttributeError: 'Pdb' object has no attribute 'curframe'. Did you mean: 'botframe'?
    "test_run_debug_twice"
    "test_run_debug_twice_with_breakpoint"
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
    changelog = "https://github.com/ipython/ipython/blob/${version}/docs/source/whatsnew/version${lib.versions.major version}.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bjornfor ];
    teams = [ lib.teams.jupyter ];
  };
}
