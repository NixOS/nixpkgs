{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchFromGitHub
, jinja2
, pygments
, markupsafe
, astunparse
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "pdoc";
  version = "12.0.2";
  disabled = pythonOlder "3.7";

  # the Pypi version does not include tests
  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "pdoc";
    rev = "v${version}";
    sha256 = "FVfPO/QoHQQqg7QU05GMrrad0CbRR5AQVYUpBhZoRi0=";
  };

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
    homepage = "https://pdoc.dev/";
    description = "API Documentation for Python Projects";
    license = licenses.unlicense;
    maintainers = with maintainers; [ pbsds ];
  };
}
