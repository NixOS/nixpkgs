{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, toolz
, multipledispatch
, py
, pytestCheckHook
, pytest-html
, pytest-benchmark
}:

buildPythonPackage rec {
  pname = "logical-unification";
  version = "0.4.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "unification";
    rev = "refs/tags/v${version}";
    hash = "sha256-uznmlkREFONU1YoI/+mcfb+Yg30NinWvsMxTfHCXzOU=";
  };

  propagatedBuildInputs = [
    toolz
    multipledispatch
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-html
    pytest-benchmark  # Needed for the `--benchmark-skip` flag
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # Failed: DID NOT RAISE <class 'RecursionError'>
    "test_reify_recursion_limit"
  ];

  pytestFlagsArray = [
    "--benchmark-skip"
    "--html=testing-report.html"
    "--self-contained-html"
  ];

  pythonImportsCheck = [ "unification" ];

  meta = with lib; {
    description = "Straightforward unification in Python that's extensible via generic functions";
    homepage = "https://github.com/pythological/unification";
    changelog = "https://github.com/pythological/unification/releases";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Etjean ];
  };
}
