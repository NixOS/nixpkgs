{ lib
, buildPythonPackage
, fetchFromGitHub
, cons
, multipledispatch
, py
, pytestCheckHook
, pytest-html
, pythonOlder
}:

buildPythonPackage rec {
  pname = "etuples";
  version = "0.3.9";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "etuples";
    rev = "refs/tags/v${version}";
    hash = "sha256-dl+exar98PnqEiCNX+Ydllp7aohsAYrFtxb2Q1Lxx6Y=";
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

  pythonImportsCheck = [
    "etuples"
  ];

  meta = with lib; {
    description = "Python S-expression emulation using tuple-like objects";
    homepage = "https://github.com/pythological/etuples";
    changelog = "https://github.com/pythological/etuples/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ Etjean ];
  };
}
