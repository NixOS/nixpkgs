{ lib
, buildPythonPackage
, fetchFromGitHub
, cons
, multipledispatch
, py
, pytestCheckHook
, pytest-html
}:

buildPythonPackage rec {
  pname = "etuples";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "etuples";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-wEgam2IoI3z75bN45/R9o+0JmL3g0YmtsuJ4TnZjhi8=";
  };

  propagatedBuildInputs = [
    cons
    multipledispatch
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-html
  ];

  pytestFlagsArray = [
    "--html=testing-report.html"
    "--self-contained-html"
  ];

  pythonImportsCheck = [ "etuples" ];

  meta = with lib; {
    description = "Python S-expression emulation using tuple-like objects";
    homepage = "https://github.com/pythological/etuples";
    changelog = "https://github.com/pythological/etuples/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ Etjean ];
  };
}
