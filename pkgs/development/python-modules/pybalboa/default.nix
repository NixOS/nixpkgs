{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
}:

buildPythonPackage rec {
  pname = "pybalboa";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "garbled1";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-08FMNRArzmfmLH6y5Z8QPcRVZJIvU3VIOvdTry3iBGI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pybalboa"
  ];

  meta = with lib; {
    description = " Python module to interface with a Balboa Spa";
    homepage = "https://github.com/garbled1/pybalboa";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
