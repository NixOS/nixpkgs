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
<<<<<<< HEAD
  version = "0.4.6";
=======
  version = "0.4.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "unification";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-uznmlkREFONU1YoI/+mcfb+Yg30NinWvsMxTfHCXzOU=";
=======
    rev = "707cf4a39e27a4a8bf06b7e7dce7223085574e65";
    hash = "sha256-3wqO0pWWFRQeoGNvbSDdLNYFyjNnv+O++F7+vTBUJoI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
