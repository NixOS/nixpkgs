{ lib
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
  version = "14.1.0";
  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "pdoc";
    rev = "v${version}";
    hash = "sha256-LQXhdzocw01URrmpDayK9rpsArvM/E44AE8Eok9DBwk=";
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
    # "test_snapshots" tries to match generated output against stored snapshots,
    # which are highly sensitive to dep versions.
    "test/test_snapshot.py"
  ];

  pytestFlagsArray = [
    ''-m "not slow"'' # skip slow tests
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
