{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, jinja2
, pdoc-pyo3-sample-library
, pygments
, markupsafe
, astunparse
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "pdoc";
  version = "14.2.0";
  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "pdoc";
    rev = "v${version}";
    hash = "sha256-Mmmq4jqRQow+1jn5ZDVMtP1uxrYgHJK/IQrwFWNw8ag=";
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
    pdoc-pyo3-sample-library
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
