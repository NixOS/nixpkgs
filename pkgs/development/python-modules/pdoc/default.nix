{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, jinja2
, pygments
, markupsafe
, astunparse
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "pdoc";
  version = "13.0.0";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  # the Pypi version does not include tests
  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "pdoc";
    rev = "v${version}";
    hash = "sha256-UzUAprvBimk2POi0QZdFuRWEeGDp+MLmdUYR0UiIubs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    jinja2
    pygments
    markupsafe
  ] ++ lib.optional (pythonOlder "3.9") astunparse;

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];
  disabledTestPaths = [
    # "test_snapshots" tries to match generated output against stored snapshots.
    # They are highly sensitive dep versions, which we unlike upstream do not pin.
    "test/test_snapshot.py"
  ];

  pytestFlagsArray = [
    ''-m "not slow"'' # skip tests marked slow
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pdoc" ];

  meta = with lib; {
    changelog = "https://github.com/mitmproxy/pdoc/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://pdoc.dev/";
    description = "API Documentation for Python Projects";
    license = licenses.unlicense;
    maintainers = with maintainers; [ pbsds ];
  };
}
