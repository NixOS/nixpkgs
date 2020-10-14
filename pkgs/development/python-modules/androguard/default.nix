{ lib
, fetchpatch
, buildPythonPackage
, fetchFromGitHub
, future
, networkx
, pygments
, lxml
, colorama
, matplotlib
, asn1crypto
, click
, pydot
, ipython
, pyqt5
, pyperclip
, nose
, nose-timer
, mock
, python_magic
, codecov
, coverage
, qt5
# This is usually used as a library, and it'd be a shame to force the gui
# libraries to the closure if gui is not desired.
, withGui ? false
# Tests take a very long time, and currently fail, but next release' tests
# shouldn't fail
, doCheck ? false
}:

buildPythonPackage rec {
  version = "3.3.5";
  pname = "androguard";

  # No tests in pypi tarball
  src = fetchFromGitHub {
    repo = pname;
    owner = pname;
    rev = "v${version}";
    sha256 = "0zc8m1xnkmhz2v12ddn47q0c01p3sbna2v5npfxhcp88szswlr9y";
  };

  propagatedBuildInputs = [
    future
    networkx
    pygments
    lxml
    colorama
    matplotlib
    asn1crypto
    click
    pydot
    ipython
  ] ++ lib.optionals withGui [
    pyqt5
    pyperclip
  ];

  checkInputs = [
    pyqt5
    pyperclip
    nose
    nose-timer
    codecov
    coverage
    mock
    python_magic
  ];
  inherit doCheck;

  nativeBuildInputs = lib.optionals withGui [ qt5.wrapQtAppsHook ];

  # If it won't be verbose, you'll see nothing going on for a long time.
  checkPhase = ''
    runHook preCheck

    nosetests --verbosity=3

    runHook postCheck
  '';

  preFixup = lib.optionalString withGui ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    description = "Tool and python library to interact with Android Files";
    homepage = "https://github.com/androguard/androguard";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.pmiddend ];
  };
}
