{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder

# Build dependencies
, glibcLocales

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
  version = "8.2.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cOXrEyysWUo0tfeZvSUliQCZBfBRBHKK6mpAPsJRncE=";
  };

  buildInputs = [
    glibcLocales
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

  LC_ALL="en_US.UTF-8";

  pythonImportsCheck = [
    "IPython"
  ];

  preCheck = ''
    export HOME=$TMPDIR

    # doctests try to fetch an image from the internet
    substituteInPlace pytest.ini \
      --replace "--ipdoctest-modules" "--ipdoctest-modules --ignore=IPython/core/display.py"
  '';

  checkInputs = [
    pytestCheckHook
    testpath
  ];

  disabledTests = lib.optionals (stdenv.isDarwin) [
    # FileNotFoundError: [Errno 2] No such file or directory: 'pbpaste'
    "test_clipboard_get"
  ];

  meta = with lib; {
    description = "IPython: Productive Interactive Computing";
    homepage = "https://ipython.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor fridh ];
  };
}
