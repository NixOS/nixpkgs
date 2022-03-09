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
, black
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

buildPythonPackage (rec {
  pname = "ipython";
  version = "8.0.1";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x19sj4dlq7r4p1mqnpx9245r8dwvpjwd8n34snfm37a452lsmmb";
  };

  buildInputs = [
    glibcLocales
  ];

  propagatedBuildInputs = [
    backcall
    black
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

  meta = with lib; {
    description = "IPython: Productive Interactive Computing";
    homepage = "http://ipython.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor fridh ];
  };
} // lib.optionalAttrs stdenv.isDarwin {
  disabledTests = [
    "test_clipboard_get" # uses pbpaste
  ];
})
