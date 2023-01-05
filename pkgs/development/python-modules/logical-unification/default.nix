{ lib
, buildPythonPackage
, fetchFromGitHub
, toolz
, multipledispatch
, py
, pytestCheckHook
, pytest-html
, pytest-benchmark
}:

buildPythonPackage rec {
  pname = "logical-unification";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "unification";
    rev = "707cf4a39e27a4a8bf06b7e7dce7223085574e65";
    sha256 = "sha256-3wqO0pWWFRQeoGNvbSDdLNYFyjNnv+O++F7+vTBUJoI=";
  };

  propagatedBuildInputs = [
    toolz
    multipledispatch
  ];

  checkInputs = [
    py
    pytestCheckHook
    pytest-html
    pytest-benchmark  # Needed for the `--benchmark-skip` flag
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
