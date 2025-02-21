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
  exceptiongroup,
  jedi,
  matplotlib-inline,
  pexpect,
  prompt-toolkit,
  pygments,
  stack-data,
  traitlets,
  typing-extensions,

  # Optional dependencies
  ipykernel,
  ipyparallel,
  ipywidgets,
  matplotlib,
  nbconvert,
  nbformat,
  notebook,
  qtconsole,

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
  version = "8.26.0";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HOwPu6hASvE/rOvoPQRDanQ0x0AOWfR6z0Z8ZKvQlWw=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
      decorator
      jedi
      matplotlib-inline
      pexpect
      prompt-toolkit
      pygments
      stack-data
      traitlets
    ]
    ++ lib.optionals (pythonOlder "3.11") [ exceptiongroup ]
    ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

  optional-dependencies = {
    kernel = [ ipykernel ];
    nbconvert = [ nbconvert ];
    nbformat = [ nbformat ];
    notebook = [
      ipywidgets
      notebook
    ];
    parallel = [ ipyparallel ];
    qtconsole = [ qtconsole ];
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

  disabledTests =
    [
      # UnboundLocalError: local variable 'child' referenced before assignment
      "test_system_interrupt"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      # FileNotFoundError: [Errno 2] No such file or directory: 'pbpaste'
      "test_clipboard_get"
    ];

  passthru.tests = {
    inherit sage;
  };

  meta = with lib; {
    description = "IPython: Productive Interactive Computing";
    downloadPage = "https://github.com/ipython/ipython/";
    homepage = "https://ipython.org/";
    changelog = "https://github.com/ipython/ipython/blob/${version}/docs/source/whatsnew/version${lib.versions.major version}.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ] ++ teams.jupyter.members;
  };
}
