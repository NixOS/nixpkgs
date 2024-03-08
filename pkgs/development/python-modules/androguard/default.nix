{ lib
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
, packaging
, pyqt5
, pyperclip
, nose
, nose-timer
, mock
, python-magic
, codecov
, coverage
, qt5
# This is usually used as a library, and it'd be a shame to force the GUI
# libraries to the closure if GUI is not desired.
, withGui ? false
# Tests take a very long time, and currently fail, but next release' tests
# shouldn't fail
, doCheck ? false
}:

buildPythonPackage rec {
  pname = "androguard";
  version = "4.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = pname;
    owner = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-NJYiuAr/rfR24pAhQDysGWXH2bBuvTrJI1jkmrJS8+c=";
  };

  nativeBuildInputs = [
    packaging
  ] ++ lib.optionals withGui [
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    asn1crypto
    click
    colorama
    future
    ipython
    lxml
    matplotlib
    networkx
    pydot
    pygments
  ] ++ lib.optionals withGui [
    pyqt5
    pyperclip
  ];

  nativeCheckInputs = [
    codecov
    coverage
    mock
    nose
    nose-timer
    pyperclip
    pyqt5
    python-magic
  ];
  inherit doCheck;

  # If it won't be verbose, you'll see nothing going on for a long time.
  checkPhase = ''
    runHook preCheck
    nosetests --verbosity=3
    runHook postCheck
  '';

  preFixup = lib.optionalString withGui ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Tool and Python library to interact with Android Files";
    homepage = "https://github.com/androguard/androguard";
    license = licenses.asl20;
    maintainers = with maintainers; [ pmiddend ];
  };
}
