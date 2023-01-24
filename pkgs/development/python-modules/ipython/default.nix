{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder

  # Build dependencies
, setuptools

  # Runtime dependencies
, appnope
, backcall
, decorator
, jedi
, matplotlib-inline
, pexpect
, pickleshare
, prompt-toolkit
, pygments
, stack-data
, traitlets

  # Test dependencies
, pytestCheckHook
, testpath
}:

buildPythonPackage rec {
  pname = "ipython";
  version = "8.8.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-878sCFBa0sP07VxGrgMxqFR9Nr9LIaRR6K6AwHkduVs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    backcall
    decorator
    jedi
    matplotlib-inline
    pexpect
    pickleshare
    prompt-toolkit
    pygments
    stack-data
    traitlets
  ] ++ lib.optionals stdenv.isDarwin [
    appnope
  ];

  pythonImportsCheck = [
    "IPython"
  ];

  preCheck = ''
    export HOME=$TMPDIR

    # doctests try to fetch an image from the internet
    substituteInPlace pytest.ini \
      --replace "--ipdoctest-modules" "--ipdoctest-modules --ignore=IPython/core/display.py"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    testpath
  ];

  disabledTests = [
    # UnboundLocalError: local variable 'child' referenced before assignment
    "test_system_interrupt"
  ] ++ lib.optionals (stdenv.isDarwin) [
    # FileNotFoundError: [Errno 2] No such file or directory: 'pbpaste'
    "test_clipboard_get"
  ];

  meta = with lib; {
    description = "IPython: Productive Interactive Computing";
    homepage = "https://ipython.org/";
    changelog = "https://github.com/ipython/ipython/blob/${version}/docs/source/whatsnew/version${lib.versions.major version}.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor fridh ];
  };
}
