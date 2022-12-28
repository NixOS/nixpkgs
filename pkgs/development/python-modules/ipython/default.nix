{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
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
  version = "8.4.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2db3a10254241d9b447232cec8b424847f338d9d36f9a577a6192c332a46abd";
  };

  patches = [
    (fetchpatch {
      # The original URL might not be very stable, so let's prefer a copy.
      urls = [
        "https://raw.githubusercontent.com/bmwiedemann/openSUSE/9b35e4405a44aa737dda623a7dabe5384172744c/packages/p/python-ipython/ipython-pr13714-xxlimited.patch"
        "https://github.com/ipython/ipython/pull/13714.diff"
      ];
      sha256 = "XPOcBo3p8mzMnP0iydns9hX8qCQXTmRgRD0TM+FESCI=";
    })
  ];

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

  checkInputs = [
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
