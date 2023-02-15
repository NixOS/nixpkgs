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
  version = "12.3.1";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  # the Pypi version does not include tests
  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "pdoc";
    rev = "v${version}";
    sha256 = "sha256-SaLrE/eHxKnlm6BZYbcZZrbrUZMeHJ4eCcqMsFvyZ7I=";
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
  disabledTests = [
    # Failing "test_snapshots" parametrization: Output does not match the stored snapshot
    # This test seems to be sensitive to ordering of dictionary items and the version of dependencies.
    # the only difference between the stored snapshot and the produced documentation is a debug javascript comment
    "html-demopackage_dir"
  ];
  pytestFlagsArray = [
    ''-m "not slow"'' # skip tests marked slow
  ];

  pythonImportsCheck = [ "pdoc" ];

  meta = with lib; {
    changelog = "https://github.com/mitmproxy/pdoc/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://pdoc.dev/";
    description = "API Documentation for Python Projects";
    license = licenses.unlicense;
    maintainers = with maintainers; [ pbsds ];
  };
}
