{ lib, buildPythonPackage, fetchFromGitHub
, pythonOlder
, importlib-resources
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "backports-zoneinfo";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "pganssle";
    repo = "zoneinfo";
    rev = version;
    sha256 = "sha256-00xdDOVdDanfsjQTd3yjMN2RFGel4cWRrAA3CvSnl24=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.7") [
    importlib-resources
  ];

  pythonImportsCheck = [ "backports.zoneinfo" ];

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  # unfortunately /etc/zoneinfo doesn't exist in sandbox, and many tests fail
  doCheck = false;

  meta = with lib; {
    description = "Backport of the standard library module zoneinfo";
    homepage = "https://github.com/pganssle/zoneinfo";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
