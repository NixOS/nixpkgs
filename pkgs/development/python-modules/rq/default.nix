{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, click
, redis
}:

buildPythonPackage rec {
  pname = "rq";
  version = "1.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    rev = "refs/tags/v${version}";
    hash = "sha256-7l/ckkDchs+iRDZLHrm4TYwA9wAJAnw9kYSaAbSo0jY=";
  };

  propagatedBuildInputs = [
    click
    redis
  ];

  # Tests require a running Redis rerver
  doCheck = false;

  pythonImportsCheck = [
    "rq"
  ];

  meta = with lib; {
    description = "Library for creating background jobs and processing them";
    homepage = "https://github.com/nvie/rq/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mrmebelman ];
  };
}

